import 'dart:async';

import 'package:rust_core/result.dart';
import 'dart:async';

typedef Sender<T> = StreamSink<T>;

extension SenderExtension<T> on Sender<T> {
  void send(T t) => add(t);
}

class RecvError {}

sealed class RecvTimeoutError {}

class TimeoutError implements RecvTimeoutError {
  final TimeoutException timeoutException;

  TimeoutError(this.timeoutException);

  @override
  String toString() {
    return 'TimeoutError: $timeoutException';
  }
}

class DisconnectedError implements RecvTimeoutError, RecvError {
  DisconnectedError();

  @override
  String toString() {
    return 'DisconnectedError';
  }
}

class OtherError implements RecvTimeoutError, RecvError {
  final Object error;

  OtherError(this.error);

  @override
  String toString() {
    return 'OtherError: $error';
  }
}

(Sender<T>, Reciever<T>) channel<T>() {
  // broadcast so no buffer
  StreamController<T> controller = StreamController<T>.broadcast();
  return (controller.sink, Reciever(controller.stream));
}

class Reciever<T> {
  late final StreamSubscription<T> _streamSubscription;
  final List<Result<T, Object>> _buffer = [];
  bool _isClosed = false;
  Completer _waker = Completer();

  bool get isClosed => _isClosed;

  Reciever(Stream<T> stream) {
    _streamSubscription = stream.listen((data) {
      assert(!_isClosed);
      _buffer.add(Ok(data));
      if (!_waker.isCompleted) {
        _waker.complete();
      }
    }, onError: (Object object, StackTrace stackTrace) {
      assert(!_isClosed);
      _buffer.add(Err(object));
      if (!_waker.isCompleted) {
        _waker.complete();
      }
    }, onDone: () {
      assert(!_isClosed);
      _isClosed = true;
      _streamSubscription.cancel();
      if (!_waker.isCompleted) {
        _waker.complete();
      }
    }, cancelOnError: false);
  }

  Future<Result<T, RecvError>> recv() async {
    try {
      return await _next();
    } catch (error) {
      return Err(OtherError(error));
    }
  }

  Future<Result<T, RecvTimeoutError>> recvTimeout(Duration timeLimit) async {
    try {
      return await _next().timeout(timeLimit).mapErr((error) => error as RecvTimeoutError);
    } on TimeoutException catch (timeoutException) {
      return Err(TimeoutError(timeoutException));
    } catch (error) {
      return Err(OtherError(error));
    }
  }

  Stream<T> asStream() async* {
    while (true) {
      final rec = await recv();
      switch (rec) {
        case Ok(:final ok):
          yield ok;
        case Err():
          break;
      }
    }
  }

  Future<Result<T, RecvError>> _next() async {
    while (true) {
      await _waker.future;
      if (_isClosed) {
        return Err(DisconnectedError());
      }
      if(_buffer.isNotEmpty){
        return _buffer.removeAt(0).mapErr((error) => OtherError(error));
      }
      _waker = Completer();
    }
  }
}
