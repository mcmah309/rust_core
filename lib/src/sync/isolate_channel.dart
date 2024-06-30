part of 'channel.dart';

class IsolateSender<T> extends Sender<T> {
  final SendPort _sPort;
  final SendCodec<T>? _codec;

  IsolateSender._(this._codec, this._sPort);

  @override
  void send(T data) {
    if (_codec == null) {
      _sPort.send(data);
    } else {
      _sPort.send(_codec.encode(data));
    }
  }
}

class IsolateReceiver<T> extends LocalReceiver<T> {
  IsolateReceiver._(SendCodec<T>? codec, ReceivePort rPort)
      : super._(rPort
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
            .cast<T>());
}

Future<(IsolateSender<T> tx1, IsolateReceiver<U> rx1)> isolateChannel<T, U>(
    FutureOr<void> Function(IsolateSender<U> tx2, IsolateReceiver<T> rx2) func,
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
    } catch (e) {
      isolateSender._sPort.send(const _CloseSignal());
      receiveFromMain.close();
      rethrow;
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

  final receiver = IsolateReceiver._(fromIsolateCodec, ReceivePort.fromRawReceivePort(receiveFromIsolate));
  final sender = IsolateSender._(toIsolateCodec, sendToIsolate!);

  return (sender, receiver);
}

class _CloseSignal {
  const _CloseSignal();
}



