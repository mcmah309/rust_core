import 'dart:async';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:rust_core/iter.dart';
import 'package:rust_core/result.dart';
import 'package:rust_core/sync.dart';

part 'isolate_channel.dart';

/// Creates a new channel, returning the [Sender] and [LocalReceiver]. Each item [T] sent by the [Sender]
/// will only be seen once by the [LocalReceiver]. If the [Sender] calls [close] while the [LocalReceiver]s buffer
/// is not empty, the [LocalReceiver] will still yield the remaining items in the buffer until empty.
(Sender<T>, Receiver<T>) channel<T>() {
  // broadcast so no buffer
  StreamController<T> controller = StreamController<T>.broadcast();
  return (LocalSender._(controller.sink), LocalReceiver._(controller.stream));
}

/// The sending-half of [channel].
abstract class Sender<T> {
  void send(T data);
}

/// The receiving-half of [channel]. [Receiver]s do not close if the [Sender] sends an error.
abstract class Receiver<T> {
  bool get isClosed;

  /// Attempts to wait for a value on this receiver, returning [Err] of:
  ///
  /// [DisconnectedError] if the [Sender] called [close] and the buffer is empty.
  ///
  /// [OtherError] if the item in the buffer is an error, indicated by the sender calling [addError].
  Future<Result<T, RecvError>> recv();

  /// Attempts to wait for a value on this receiver with a time limit, returning [Err] of:
  ///
  /// [DisconnectedError] if the [Sender] called [close] and the buffer is empty.
  ///
  /// [OtherError] if the item in the buffer is an error, indicated by the sender calling [addError].
  ///
  /// [TimeoutError] if the time limit is reached before the [Sender] sent any more data.
  Future<Result<T, RecvTimeoutError>> recvTimeout(Duration timeLimit);

  /// Returns an [RIterator] that drains the current buffer.
  RIterator<T> iter();

  /// Returns a [Stream] of values ending once [DisconnectedError] is yielded.
  Stream<T> stream();
}

//************************************************************************//

/// [Sender] for a single isolate.
class LocalSender<T> implements Sender<T> {
  final StreamSink<T> sink;

  LocalSender._(this.sink);

  @override
  void send(T data) => sink.add(data);
}

/// [Receiver] for a single isolate.
class LocalReceiver<T> implements Receiver<T> {
  late final StreamSubscription<T> _streamSubscription;
  final List<Result<T, Object>> _buffer = [];
  bool _isClosed = false;
  Completer _waker = Completer();

  @override
  bool get isClosed => _isClosed;

  LocalReceiver._(Stream<T> stream) {
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

  @override
  Future<Result<T, RecvError>> recv() async {
    try {
      return await _next();
    } catch (error) {
      return Err(OtherError(error));
    }
  }

  @override
  Future<Result<T, RecvTimeoutError>> recvTimeout(Duration timeLimit) async {
    try {
      return await _next()
          .timeout(timeLimit)
          .mapErr((error) => error as RecvTimeoutError);
    } on TimeoutException catch (timeoutException) {
      return Err(TimeoutError(timeoutException));
    } catch (error) {
      return Err(OtherError(error));
    }
  }

  @override
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

  @override
  Stream<T> stream() async* {
    while (true) {
      final rec = await recv();
      switch (rec) {
        case Ok(:final ok):
          yield ok;
        case Err(:final err):
          switch (err) {
            case DisconnectedError():
              return;
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

/// An error returned from the [recv] function on a [LocalReceiver].
class RecvError {}

/// An error returned from the [recvTimeout] function on a [LocalReceiver].
sealed class RecvTimeoutError {}

/// An error returned from the [recvTimeout] function on a [LocalReceiver] when the time limit is reached before the [Sender] sends any data.
class TimeoutError implements RecvTimeoutError {
  final TimeoutException timeoutException;

  TimeoutError(this.timeoutException);

  @override
  String toString() {
    return 'TimeoutError: $timeoutException';
  }

  @override
  bool operator ==(Object other) {
    return other is TimeoutError;
  }

  @override
  int get hashCode {
    return 0;
  }
}

/// An error returned from the [recv] function on a [LocalReceiver] when the [Sender] called [close].
class DisconnectedError implements RecvTimeoutError, RecvError {
  DisconnectedError();

  @override
  String toString() {
    return 'DisconnectedError';
  }

  @override
  bool operator ==(Object other) {
    return other is DisconnectedError;
  }

  @override
  int get hashCode {
    return 0;
  }
}

/// An error returned from the [recv] function on a [LocalReceiver] when the [Sender] called [addError].
class OtherError implements RecvTimeoutError, RecvError {
  final Object error;

  OtherError(this.error);

  @override
  String toString() {
    return 'OtherError: $error';
  }

  @override
  bool operator ==(Object other) {
    return other is OtherError;
  }

  @override
  int get hashCode {
    return 0;
  }
}
