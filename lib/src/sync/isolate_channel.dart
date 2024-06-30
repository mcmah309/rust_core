part of 'channel.dart';

class IsolateSender<T> extends Sender<T> {
  final SendPort _sPort;
  final SendCodec<T> _codec;

  IsolateSender._(this._codec, this._sPort);

  @override
  void send(T data) {
    _sPort.send(_codec.encode(data));
  }
}

class IsolateReceiver<T> extends LocalReceiver<T> {
  IsolateReceiver._(SendCodec<T> codec, ReceivePort rPort)
      : super._(rPort
            .map((data) {
              if (data is _CloseSignal) {
                rPort.close();
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

  // Work-around for not being able to pass Completers since 'dart:async` is now unsendable.
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

//************************************************************************//

/// The codec use to encode and decode data send over the channel.
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

class IntCodec implements SendCodec<int> {
  const IntCodec();

  @override
  int decode(ByteBuffer buffer) {
    return buffer.asByteData().getInt64(0, Endian.big);
  }

  @override
  ByteBuffer encode(int data) {
    final bytes = ByteData(8);
    bytes.setInt64(0, data, Endian.big);
    return bytes.buffer;
  }
}

class DoubleCodec implements SendCodec<double> {
  const DoubleCodec();

  @override
  double decode(ByteBuffer buffer) {
    return buffer.asByteData().getFloat64(0, Endian.big);
  }

  @override
  ByteBuffer encode(double data) {
    final bytes = ByteData(8);
    bytes.setFloat64(0, data, Endian.big);
    return bytes.buffer;
  }
}

class BooleanCodec implements SendCodec<bool> {
  const BooleanCodec();

  @override
  bool decode(ByteBuffer buffer) {
    return buffer.asByteData().getUint8(0) == 1;
  }

  @override
  ByteBuffer encode(bool data) {
    final bytes = ByteData(1);
    bytes.setUint8(0, data ? 1 : 0);
    return bytes.buffer;
  }
}

//************************************************************************//

class ListSizedTCodec<T> implements SendCodec<List<T>> {
  final SendCodec<T> _codec;
  final int _bytesPerT;

  const ListSizedTCodec(this._codec, this._bytesPerT) : assert(_bytesPerT > 0);

  @override
  List<T> decode(ByteBuffer buffer) {
    final byteData = buffer.asByteData();
    final length = byteData.getInt64(0, Endian.big);
    assert(byteData.lengthInBytes == 8 + length * _bytesPerT);
    final list = List<T?>.filled(length, null);
    for (int i = 0; i < length; i++) {
      final elementBytes = ByteData(_bytesPerT);
      for (int j = 0; j < _bytesPerT; j++) {
        elementBytes.setUint8(j, byteData.getUint8(8 + j + i * _bytesPerT));
      }
      list[i] = _codec.decode(elementBytes.buffer);
    }
    return list.cast<T>();
  }

  @override
  ByteBuffer encode(List<T> data) {
    final length = data.length;
    final bytes = ByteData(8 + length * _bytesPerT);
    bytes.setInt64(0, length, Endian.big);
    for (int i = 0; i < data.length; i++) {
      final elementBytes = _codec.encode(data[i]).asByteData();
      assert(elementBytes.lengthInBytes == _bytesPerT);
      for (int j = 0; j < _bytesPerT; j++) {
        bytes.setUint8(8 + j + i * _bytesPerT, elementBytes.getUint8(j));
      }
    }
    return bytes.buffer;
  }
}

class IntListCodec extends ListSizedTCodec<int> {
  const IntListCodec() : super(const IntCodec(), 8);
}

class DoubleListCodec extends ListSizedTCodec<double> {
  const DoubleListCodec() : super(const DoubleCodec(), 8);
}

class BooleanListCodec extends ListSizedTCodec<bool> {
  const BooleanListCodec() : super(const BooleanCodec(), 1);
}
