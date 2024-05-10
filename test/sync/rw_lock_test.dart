import 'dart:async';
import 'package:rust_core/sync.dart';
import 'package:test/test.dart';

class RWTester {
  int _operation = 0;
  final _operationSequences = <int>[];

  /// Execution sequence of the operations done.
  ///
  /// Each element corresponds to the position of the initial execution
  /// order of the read/write operation future.
  List<int> get operationSequences => _operationSequences;

  RwLock mutex = RwLock();

  /// Set to true to print out read/write to the balance during deposits
  static final bool debugOutput = false;

  final DateTime _startTime = DateTime.now();

  void _debugPrint(String message) {
    if (debugOutput) {
      final t = DateTime.now().difference(_startTime).inMilliseconds;
      print('$t: $message');
    }
  }

  void reset() {
    _operationSequences.clear();
    _debugPrint('reset');
  }

  /// Waits [startDelay] and then invokes critical section with mutex.
  ///
  /// Writes to [_operationSequences]. If the readwrite locks are respected
  /// then the final state of the list will be in ascending order.
  Future<void> writing(int startDelay, int sequence, int endDelay) async {
    await Future<void>.delayed(Duration(milliseconds: startDelay));

    await mutex.withWriteLock(() async {
      final op = ++_operation;
      _debugPrint('[$op] write start: <- $_operationSequences');
      final tmp = _operationSequences;
      expect(mutex.isWriteLocked, isTrue);
      expect(_operationSequences, orderedEquals(tmp));
      // Add the position of operation to the list of operations.
      _operationSequences.add(sequence); // add position to list
      expect(mutex.isWriteLocked, isTrue);
      await Future<void>.delayed(Duration(milliseconds: endDelay));
      _debugPrint('[$op] write finish: -> $_operationSequences');
    });
  }

  /// Waits [startDelay] and then invokes critical section with mutex.
  ///
  ///
  Future<void> reading(int startDelay, int sequence, int endDelay) async {
    await Future<void>.delayed(Duration(milliseconds: startDelay));

    await mutex.withReadLock(() async {
      final op = ++_operation;
      _debugPrint('[$op] read start: <- $_operationSequences');
      expect(mutex.isReadLocked, isTrue);
      _operationSequences.add(sequence); // add position to list
      await Future<void>.delayed(Duration(milliseconds: endDelay));
      _debugPrint('[$op] read finish: <- $_operationSequences');
    });
  }
}

//################################################################

//----------------------------------------------------------------

void main() {
  final account = RWTester();

  setUp(account.reset);

  test('multiple read locks', () async {
    await Future.wait([
      account.reading(0, 1, 1000),
      account.reading(0, 2, 900),
      account.reading(0, 3, 800),
      account.reading(0, 4, 700),
      account.reading(0, 5, 600),
      account.reading(0, 6, 500),
      account.reading(0, 7, 400),
      account.reading(0, 8, 300),
      account.reading(0, 9, 200),
      account.reading(0, 10, 100),
    ]);
    // The first future acquires the lock first and waits the longest to give it
    // up. This should however not block any of the other read operations
    // as such the reads should finish in ascending orders.
    expect(
      account.operationSequences,
      orderedEquals(<int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]),
    );
  });

  test('multiple write locks', () async {
    await Future.wait([
      account.writing(0, 1, 100),
      account.writing(0, 2, 100),
      account.writing(0, 3, 100),
    ]);
    // The first future writes first and holds the lock until 100 ms
    // Even though the second future starts execution, the lock cannot be
    // acquired until it is released by the first future.
    // Therefore the sequence of operations will be in ascending order
    // of the futures.
    expect(
      account.operationSequences,
      orderedEquals(<int>[1, 2, 3]),
    );
  });

  test('write() before read()', () async {
    const lockTimeout = Duration(milliseconds: 100);

    final mutex = RwLock();

    await mutex.write();
    expect(mutex.isReadLocked, equals(false));
    expect(mutex.isWriteLocked, equals(true));

    // Since there is a write lock existing, a read lock cannot be acquired.
    final readLock = mutex.read().timeout(lockTimeout);
    expect(
      () async => (await readLock),
      throwsA(isA<TimeoutException>()),
    );
  });

  test('read() before write()', () async {
    const lockTimeout = Duration(milliseconds: 100);

    final mutex = RwLock();

    await mutex.read();
    expect(mutex.isReadLocked, equals(true));
    expect(mutex.isWriteLocked, equals(false));

    // Since there is a read lock existing, a write lock cannot be acquired.
    final writeLock = mutex.write().timeout(lockTimeout);
    expect(
      () async => await writeLock,
      throwsA(isA<TimeoutException>()),
    );
  });

  test('mixture of read write locks execution order', () async {
    await Future.wait([
      account.reading(0, 1, 100),
      account.reading(10, 2, 100),
      account.reading(20, 3, 100),
      account.writing(30, 4, 100),
      account.writing(40, 5, 100),
      account.writing(50, 6, 100),
    ]);

    expect(
      account.operationSequences,
      orderedEquals(<int>[1, 2, 3, 4, 5, 6]),
    );
  });

  group('withReadLock', () {
    test('lock obtained and released on success', () async {
      final m = RwLock();

      await m.withReadLock(() async {
        // critical section
        expect(m.isLocked, isTrue);
      });
      expect(m.isLocked, isFalse);
    });

    test('value returned from critical section', () async {
      // These are the normal scenario of the critical section running
      // successfully. It tests different return types from the
      // critical section.

      final m = RwLock();

      // returns Future<void>
      await m.withReadLock<void>(() async {});

      // returns Future<int>
      final number = await m.withReadLock<int>(() async => 42);
      expect(number, equals(42));

      // returns Future<int?> completes with value
      final optionalNumber = await m.withReadLock<int?>(() async => 1024);
      expect(optionalNumber, equals(1024));

      // returns Future<int?> completes with null
      final optionalNumberNull = await m.withReadLock<int?>(() async => null);
      expect(optionalNumberNull, isNull);

      // returns Future<String>
      final word = await m.withReadLock<String>(() async => 'foobar');
      expect(word, equals('foobar'));

      // returns Future<String?> completes with value
      final optionalWord = await m.withReadLock<String?>(() async => 'baz');
      expect(optionalWord, equals('baz'));

      // returns Future<String?> completes with null
      final optionalWordNull = await m.withReadLock<String?>(() async => null);
      expect(optionalWordNull, isNull);

      expect(m.isLocked, isFalse);
    });

    test('exception in synchronous code', () async {
      // Tests what happens when an exception is raised in the **synchronous**
      // part of the critical section.
      //
      // Locks are correctly managed: the lock is obtained before executing
      // the critical section, and is released when the exception is thrown
      // by the _protect_ method.
      //
      // The exception is raised when waiting for the Future returned by
      // _protect_ to complete. Even though the exception is synchronously
      // raised by the critical section, it won't be thrown when _protect_
      // is invoked. The _protect_ method always successfully returns a
      // _Future_.

      Future<int> criticalSection() {
        final c = Completer<int>()..complete(42);

        // synchronous exception
        throw const FormatException('synchronous exception');
        // ignore: dead_code
        return c.future;
      }

      // Check the criticalSection behaves as expected for the test

      try {
        // ignore: unused_local_variable
        final resultFuture = criticalSection();
        fail('critical section did not throw synchronous exception');
      } on FormatException {
        // expected: invoking the criticalSection results in the exception
      }

      final m = RwLock();

      try {
        // Invoke protect to get the Future (this should succeed)
        final resultFuture = m.withReadLock<int>(criticalSection);
        expect(resultFuture, isA<Future>());

        // Wait for the Future (this should fail)
        final result = await resultFuture;
        expect(result, isNotNull);
        fail('exception not thrown');
      } on FormatException catch (e) {
        expect(m.isLocked, isFalse);
        expect(e.message, equals('synchronous exception'));
      }

      expect(m.isLocked, isFalse);
    });

    test('exception in asynchronous code', () async {
      // Tests what happens when an exception is raised in the **asynchronous**
      // part of the critical section.
      //
      // Locks are correctly managed: the lock is obtained before executing
      // the critical section, and is released when the exception is thrown
      // by the _protect_ method.
      //
      // The exception is raised when waiting for the Future returned by
      // _protect_ to complete.

      Future<int> criticalSection() async {
        final c = Completer<int>()..complete(42);

        await Future.delayed(const Duration(seconds: 1), () {});

        // asynchronous exception (since it must wait for the above line)
        throw const FormatException('asynchronous exception');
        // ignore: dead_code
        return c.future;
      }

      // Check the criticalSection behaves as expected for the test

      final resultFuture = criticalSection();
      expect(resultFuture, isA<Future>());
      // invoking the criticalSection does not result in the exception
      try {
        await resultFuture;
        fail('critical section did not throw asynchronous exception');
      } on FormatException {
        // expected: exception happens on the await
      }

      final m = RwLock();

      try {
        // Invoke protect to get the Future (this should succeed)
        final resultFuture = m.withReadLock<int>(criticalSection);
        expect(resultFuture, isA<Future>());

        // Even though the criticalSection throws the exception in synchronous
        // code, protect causes it to become an asynchronous exception.

        // Wait for the Future (this should fail)
        final result = await resultFuture;
        expect(result, isNotNull);
        fail('exception not thrown');
      } on FormatException catch (e) {
        expect(m.isLocked, isFalse);
        expect(e.message, equals('asynchronous exception'));
      }

      expect(m.isLocked, isFalse);
    });
  });

  group('withWriteLock', () {
    test('lock obtained and released on success', () async {
      final m = RwLock();

      await m.withWriteLock(() async {
        // critical section
        expect(m.isLocked, isTrue);
      });
      expect(m.isLocked, isFalse);
    });

    test('value returned from critical section', () async {
      // These are the normal scenario of the critical section running
      // successfully. It tests different return types from the
      // critical section.

      final m = RwLock();

      // returns Future<void>
      await m.withWriteLock<void>(() async {});

      // returns Future<int>
      final number = await m.withWriteLock<int>(() async => 42);
      expect(number, equals(42));

      // returns Future<int?> completes with value
      final optionalNumber = await m.withWriteLock<int?>(() async => 1024);
      expect(optionalNumber, equals(1024));

      // returns Future<int?> completes with null
      final optionalNumberNull = await m.withWriteLock<int?>(() async => null);
      expect(optionalNumberNull, isNull);

      // returns Future<String>
      final word = await m.withWriteLock<String>(() async => 'foobar');
      expect(word, equals('foobar'));

      // returns Future<String?> completes with value
      final optionalWord = await m.withWriteLock<String?>(() async => 'baz');
      expect(optionalWord, equals('baz'));

      // returns Future<String?> completes with null
      final optionalWordNull = await m.withWriteLock<String?>(() async => null);
      expect(optionalWordNull, isNull);

      expect(m.isLocked, isFalse);
    });

    test('exception in synchronous code', () async {
      // Tests what happens when an exception is raised in the **synchronous**
      // part of the critical section.
      //
      // Locks are correctly managed: the lock is obtained before executing
      // the critical section, and is released when the exception is thrown
      // by the _protect_ method.
      //
      // The exception is raised when waiting for the Future returned by
      // _protect_ to complete. Even though the exception is synchronously
      // raised by the critical section, it won't be thrown when _protect_
      // is invoked. The _protect_ method always successfully returns a
      // _Future_.

      Future<int> criticalSection() {
        final c = Completer<int>()..complete(42);

        // synchronous exception
        throw const FormatException('synchronous exception');
        // ignore: dead_code
        return c.future;
      }

      // Check the criticalSection behaves as expected for the test

      try {
        // ignore: unused_local_variable
        final resultFuture = criticalSection();
        fail('critical section did not throw synchronous exception');
      } on FormatException {
        // expected: invoking the criticalSection results in the exception
      }

      final m = RwLock();

      try {
        // Invoke protect to get the Future (this should succeed)
        final resultFuture = m.withWriteLock<int>(criticalSection);
        expect(resultFuture, isA<Future>());

        // Wait for the Future (this should fail)
        final result = await resultFuture;
        expect(result, isNotNull);
        fail('exception not thrown');
      } on FormatException catch (e) {
        expect(m.isLocked, isFalse);
        expect(e.message, equals('synchronous exception'));
      }

      expect(m.isLocked, isFalse);
    });

    test('exception in asynchronous code', () async {
      // Tests what happens when an exception is raised in the **asynchronous**
      // part of the critical section.
      //
      // Locks are correctly managed: the lock is obtained before executing
      // the critical section, and is released when the exception is thrown
      // by the _protect_ method.
      //
      // The exception is raised when waiting for the Future returned by
      // _protect_ to complete.

      Future<int> criticalSection() async {
        final c = Completer<int>()..complete(42);

        await Future.delayed(const Duration(seconds: 1), () {});

        // asynchronous exception (since it must wait for the above line)
        throw const FormatException('asynchronous exception');
        // ignore: dead_code
        return c.future;
      }

      // Check the criticalSection behaves as expected for the test

      final resultFuture = criticalSection();
      expect(resultFuture, isA<Future>());
      // invoking the criticalSection does not result in the exception
      try {
        await resultFuture;
        fail('critical section did not throw asynchronous exception');
      } on FormatException {
        // expected: exception happens on the await
      }

      final m = RwLock();

      try {
        // Invoke protect to get the Future (this should succeed)
        final resultFuture = m.withWriteLock<int>(criticalSection);
        expect(resultFuture, isA<Future>());

        // Even though the criticalSection throws the exception in synchronous
        // code, protect causes it to become an asynchronous exception.

        // Wait for the Future (this should fail)
        final result = await resultFuture;
        expect(result, isNotNull);
        fail('exception not thrown');
      } on FormatException catch (e) {
        expect(m.isLocked, isFalse);
        expect(e.message, equals('asynchronous exception'));
      }

      expect(m.isLocked, isFalse);
    });
  });
}