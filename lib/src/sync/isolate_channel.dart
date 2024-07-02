part of 'channel.dart';

Finalizer<SendPort> _sendFinalizer = Finalizer((sPort) {
  sPort.send(const _CloseSignal());
});

Finalizer<ReceivePort> _receiveFinalizer = Finalizer((rPort) {
  rPort.close();
});

class IsolateSender<T> extends Sender<T> {
  final SendPort _sPort;
  final SendCodec<T>? _codec;

  IsolateSender._(this._codec, this._sPort) {
    _sendFinalizer.attach(this, _sPort);
  }

  /// Sends the [data] to the isolate, the isolate may or may not receive the data depending on if the
  /// isolate has terminated or [close] has been called.
  @override
  void send(T data) {
    if (_codec == null) {
      _sPort.send(data);
    } else {
      _sPort.send(_codec.encode(data));
    }
  }

  /// Closes the port on the isolate. Good practice to call, otherwise the port will eventually
  /// close on it's own when this goes out of scope. Calling may result in the port closing before
  /// previous [send] operations have succeeded.
  void close() => _sPort.send(const _CloseSignal());
}

class IsolateReceiver<T> extends _ReceiverImpl<T> {
  IsolateReceiver._(SendCodec<T>? codec, ReceivePort rPort)
      : super._(
            rPort
                .map((data) {
                  if (data is _CloseSignal) {
                    rPort.close();
                    return null;
                  } else if (codec != null) {
                    return codec.decode(data as ByteBuffer);
                  } else {
                    return data as T;
                  }
                })
                .where((event) => event != null)
                .cast<T>(),
            () async => rPort.close()) {
    _receiveFinalizer.attach(this, rPort);
  }
}

/// [isolateChannel] is used for bi-directional isolate communication. The returned
/// [Sender] and [Receiver] can communicate with the spawned isolate and
/// the spawned isolate is passed a [Sender] and [Receiver] to communicate with the original isolate.
/// Each item `T` sent by a [Sender] will only be seen once by the corresponding [Receiver].
/// If the [Sender] calls `close` while the [Receiver]'s buffer
/// is not empty, the [Receiver] will still yield the remaining items in the buffer until empty.
/// Types that can be sent over a [SendPort], as defined here https://api.flutter.dev/flutter/dart-isolate/SendPort/send.html ,
/// are allow to be sent between isolates. Otherwise a [toIsolateCodec] and/or a [fromIsolateCodec] can be passed
/// to encode and decode the messages.
Future<(IsolateSender<T> tx, IsolateReceiver<U> rx)> isolateChannel<T, U>(
    FutureOr<void> Function(IsolateSender<U> tx, IsolateReceiver<T> rx) func,
    {SendCodec<T>? toIsolateCodec,
    SendCodec<U>? fromIsolateCodec}) async {
  final receiveFromIsolate = RawReceivePort();
  SendPort? sendToIsolate;
  receiveFromIsolate.handler = (sendPort) {
    sendToIsolate = sendPort as SendPort;
  };
  void startIsolate(SendPort sendToMain) async {
    final receiveFromMain = ReceivePort();
    sendToMain.send(receiveFromMain.sendPort);

    final isolateReceiver = IsolateReceiver._(toIsolateCodec, receiveFromMain);
    final isolateSender = IsolateSender._(fromIsolateCodec, sendToMain);

    try {
      await func(isolateSender, isolateReceiver);
    } finally {
      isolateSender._sPort.send(const _CloseSignal());
      receiveFromMain.close();
    }
  }

  try {
    await Isolate.spawn(startIsolate, (receiveFromIsolate.sendPort));
  } catch (e) {
    receiveFromIsolate.close();
    rethrow;
  }

  // Work-around for not being able to pass Completers since 'dart:async` is now unsendable.
  // Should only loop zero to two times based on Dart's async scheduler.
  while (sendToIsolate == null) {
    await Future.delayed(Duration.zero);
  }

  final receiver =
      IsolateReceiver._(fromIsolateCodec, ReceivePort.fromRawReceivePort(receiveFromIsolate));
  final sender = IsolateSender._(toIsolateCodec, sendToIsolate!);

  return (sender, receiver);
}

class _CloseSignal {
  const _CloseSignal();
}
