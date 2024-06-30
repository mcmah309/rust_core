import 'dart:async';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:rust_core/src/result/result.dart';
import 'package:rust_core/src/sync/channel.dart';

void main() async {
  final (tx, rx) = await isolateChannel<String>(const StringCodec(), (tx2, rx2) async {
    print(await rx2.recv());
  });
  tx.send("hello1");
  // Isolate.spawn((message) => print("isolate"), null);
  print("done");
}

// void x() async {
//   final (rx, tx) = channel<String>();
//   final rPort = RawReceivePort((data) => print("hello"));
//   final sPort = rPort.sendPort;
//   ReceivePort.fromRawReceivePort(rPort);
//   sPort.send("");
//   await Future.delayed(Duration(seconds: 1));
//   rPort.close();
// }

abstract class SendCodec<T> {
  const SendCodec();

  T decode(ByteBuffer buffer);

  ByteBuffer encode(T instance);
}

class StringCodec implements SendCodec<String> {
  const StringCodec();

  @override
  String decode(ByteBuffer buffer) {
    return String.fromCharCodes(buffer.asUint8List());
  }

  @override
  ByteBuffer encode(String data) {
    return Uint8List.fromList(data.codeUnits).buffer;
  }
}

class IsolateSender<T> {
  final SendPort _sPort;
  final SendCodec<T> _codec;

  IsolateSender._(this._codec, this._sPort);

  void send(T data) {
    _sPort.send(_codec.encode(data));
  }
}

class IsolateReceiver<T> extends Receiver<T> {
  final ReceivePort _rPort;

  IsolateReceiver._(SendCodec<T> codec, this._rPort)
      : super(_rPort
            .map((data) {
              if (data is _CloseSignal) {
                _rPort.close();
                return null;
              } else {
                return codec.decode(data as ByteBuffer);
              }
            })
            .where((event) => event != null)
            .cast<T>());
}

Future<(IsolateSender<T> tx1, IsolateReceiver<T> rx1)> isolateChannel<T>(SendCodec<T> codec,
    FutureOr<void> Function(IsolateSender<T> tx2, IsolateReceiver<T> rx2) func) async {
  final receiveFromIsolate = RawReceivePort();
  SendPort? sendToIsolate;
  receiveFromIsolate.handler = (sendPort) {
    sendToIsolate = sendPort as SendPort;
  };
  void startIsolate(SendPort sendToMain) async {
    final receiveFromMain = ReceivePort();
    sendToMain.send(receiveFromMain.sendPort);

    final isolateReceiver = IsolateReceiver._(codec, receiveFromMain);
    final isolateSender = IsolateSender._(codec, sendToMain);

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

  // Workaround for not being able to pass Completers since 'dart:async` is now unsendable.
  // Should only be called zero to two times.
  while (sendToIsolate == null) {
    await Future.delayed(Duration.zero);
  }

  final receiver = IsolateReceiver._(codec, ReceivePort.fromRawReceivePort(receiveFromIsolate));
  final sender = IsolateSender._(codec, sendToIsolate!);

  return (sender, receiver);
}

class _CloseSignal {
  const _CloseSignal();
}
