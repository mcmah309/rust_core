import 'dart:async';

import 'package:rust_core/iter.dart';
import 'package:rust_core/result.dart';

/// Creates a new mpsc channel, returning the [Sender] and [Reciever]. Each item [T] sent by the [Sender]
/// will only be seen once by the [Reciever]. If the [Sender] calls [close] while the [Reciever]s buffer
/// is not empty, the [Reciever] will yield the remaining items in the buffer until empty.
(Sender<T>, Reciever<T>) channel<T>() {
  // broadcast so no buffer
  StreamController<T> controller = StreamController<T>.broadcast();
  return (controller.sink, Reciever(controller.stream));
}

/// The sending-half of [channel].
typedef Sender<T> = StreamSink<T>;

extension SenderExtension<T> on Sender<T> {
  void send(T t) => add(t);

  void sendError(Object t) => addError(t);
}

/// The recieving-half of [channel]. [Reciever]s do not close if the [Sender] sends an error.
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

  /// Attempts to wait for a value on this receiver, returning [Err] of:
  /// 
  /// [DisconnectedError] if the [Sender] called [close] and the buffer is empty.
  /// 
  /// [OtherError] if the item in the buffer is an error, indicated by the sender calling [addError].
  Future<Result<T, RecvError>> recv() async {
    try {
      return await _next();
    } catch (error) {
      return Err(OtherError(error));
    }
  }

  /// Attempts to wait for a value on this receiver with a time limit, returning [Err] of:
  /// 
  /// [DisconnectedError] if the [Sender] called [close] and the buffer is empty.
  /// 
  /// [OtherError] if the item in the buffer is an error, indicated by the sender calling [addError].
  /// 
  /// [TimeoutError] if the time limit is reached before the [Sender] sent any more data.
  Future<Result<T, RecvTimeoutError>> recvTimeout(Duration timeLimit) async {
    try {
      return await _next().timeout(timeLimit).mapErr((error) => error as RecvTimeoutError);
    } on TimeoutException catch (timeoutException) {
      return Err(TimeoutError(timeoutException));
    } catch (error) {
      return Err(OtherError(error));
    }
  }

  /// Returns an [RIterator] that drains the current buffer.
  RIterator<T> iter() {
    return RIterator.fromIterable(_iter());
  }

  Iterable<T> _iter() sync* {
    while (_buffer.isNotEmpty) {
      final item = _buffer.removeAt(0);
      switch (item) {
        case Ok(:final ok):
          yield ok;
        case Err():
      }
    }
  }

  /// Returns a [Stream] of values ending once [DisconnectedError] is yielded.
  Stream<T> stream() async* {
    while (true) {
      final rec = await recv();
      switch (rec) {
        case Ok(:final ok):
          yield ok;
        case Err(:final err):
          switch(err){
            case DisconnectedError():
              break;
            default:
          }
      }
    }
  }

  Future<Result<T, RecvError>> _next() async {
    while (true) {
      await _waker.future;
      if (_isClosed) {
        return Err(DisconnectedError());
      }
      if (_buffer.isNotEmpty) {
        return _buffer.removeAt(0).mapErr((error) => OtherError(error));
      }
      _waker = Completer();
    }
  }
}

//************************************************************************//

/// An error returned from the [recv] function on a [Receiver].
class RecvError {}

/// An error returned from the [recvTimeout] function on a [Receiver].
sealed class RecvTimeoutError {}

/// An error returned from the [recvTimeout] function on a [Receiver] when the time limit is reached before the [Sender] sends any data.
class TimeoutError implements RecvTimeoutError {
  final TimeoutException timeoutException;

  TimeoutError(this.timeoutException);

  @override
  String toString() {
    return 'TimeoutError: $timeoutException';
  }
}

/// An error returned from the [recv] function on a [Receiver] when the [Sender] called [close].
class DisconnectedError implements RecvTimeoutError, RecvError {
  DisconnectedError();

  @override
  String toString() {
    return 'DisconnectedError';
  }
}

/// An error returned from the [recv] function on a [Receiver] when the [Sender] called [addError].
class OtherError implements RecvTimeoutError, RecvError {
  final Object error;

  OtherError(this.error);

  @override
  String toString() {
    return 'OtherError: $error';
  }
}