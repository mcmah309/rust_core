import 'dart:async';
import 'package:rust_core/sync.dart';
import 'package:test/test.dart';

/// Account simulating the classic "simultaneous update" concurrency problem.
///
/// The deposit operation reads the balance, waits for a short time (where
/// problems can occur if the balance is changed) and then writes out the
/// new balance.
///
class Account {
  int get balance => _balance;
  int _balance = 0;

  int _operation = 0;

  Mutex mutex = Mutex();

  /// Set to true to print out read/write to the balance during deposits
  static final bool debugOutput = false;

  /// Time used for calculating time offsets in debug messages.
  final DateTime _startTime = DateTime.now();

  void _debugPrint(String message) {
    if (debugOutput) {
      final t = DateTime.now().difference(_startTime).inMilliseconds;
      print('$t: $message');
    }
  }

  void reset([int startingBalance = 0]) {
    _balance = startingBalance;
    _debugPrint('reset: balance = $_balance');
  }

  /// Waits [startDelay] and then invokes critical section without mutex.
  ///
  Future<void> depositUnsafe(
      int amount, int startDelay, int dangerWindow) async {
    await Future<void>.delayed(Duration(milliseconds: startDelay));

    await _depositCriticalSection(amount, dangerWindow);
  }

  /// Waits [startDelay] and then invokes critical section with mutex.
  ///
  Future<void> depositWithMutex(
      int amount, int startDelay, int dangerWindow) async {
    await Future<void>.delayed(Duration(milliseconds: startDelay));

    await mutex.lock();
    try {
      expect(mutex.isLocked, isTrue);
      await _depositCriticalSection(amount, dangerWindow);
      expect(mutex.isLocked, isTrue);
    } finally {
      mutex.release();
    }
  }

  /// Critical section of adding [amount] to the balance.
  ///
  /// Reads the balance, then sleeps for [dangerWindow] milliseconds, before
  /// saving the new balance. If not protected, another invocation of this
  /// method while it is sleeping will read the balance before it is updated.
  /// The one that saves its balance last will overwrite the earlier saved
  /// balances (effectively those other deposits will be lost).
  ///
  Future _depositCriticalSection(int amount, int dangerWindow) async {
    final op = ++_operation;

    _debugPrint('[$op] read balance: $_balance');

    final tmp = _balance;

    await Future<void>.delayed(Duration(milliseconds: dangerWindow));

    _balance = tmp + amount;

    _debugPrint('[$op] write balance: $_balance (= $tmp + $amount)');
  }
}

//************************************************************************//

void main() {
  final correctBalance = 68;

  final account = Account();

  test('without mutex', () async {
    // First demonstrate that without mutex incorrect results are produced.

    // Without mutex produces incorrect result
    // 000. a reads 0
    // 025. b reads 0
    // 050. a writes 42
    // 075. b writes 26
    account.reset();
    await Future.wait<void>([
      account.depositUnsafe(42, 0, 50),
      account.depositUnsafe(26, 25, 50) // result overwrites first deposit
    ]);
    expect(account.balance, equals(26)); // incorrect: first deposit lost

    // Without mutex produces incorrect result
    // 000. b reads 0
    // 025. a reads 0
    // 050. b writes 26
    // 075. a writes 42
    account.reset();
    await Future.wait([
      account.depositUnsafe(42, 25, 50), // result overwrites second deposit
      account.depositUnsafe(26, 0, 50)
    ]);
    expect(account.balance, equals(42)); // incorrect: second deposit lost
  });

  test('with mutex', () async {
// Test correct results are produced with mutex

    // With mutex produces correct result
    // 000. a acquires lock
    // 000. a reads 0
    // 025. b is blocked
    // 050. a writes 42
    // 050. a releases lock
    // 050. b acquires lock
    // 050. b reads 42
    // 100. b writes 68
    account.reset();
    await Future.wait([
      account.depositWithMutex(42, 0, 50),
      account.depositWithMutex(26, 25, 50)
    ]);
    expect(account.balance, equals(correctBalance));

    // With mutex produces correct result
    // 000. b acquires lock
    // 000. b reads 0
    // 025. a is blocked
    // 050. b writes 26
    // 050. b releases lock
    // 050. a acquires lock
    // 050. a reads 26
    // 100. a writes 68
    account.reset();
    await Future.wait([
      account.depositWithMutex(42, 25, 50),
      account.depositWithMutex(26, 0, 50)
    ]);
    expect(account.balance, equals(correctBalance));
  });

  test('multiple acquires are serialized', () async {
    // Demonstrate that sections running in a mutex are effectively serialized
    const delay = 200; // milliseconds
    account.reset();
    await Future.wait([
      account.depositWithMutex(1, 0, delay),
      account.depositWithMutex(1, 0, delay),
      account.depositWithMutex(1, 0, delay),
      account.depositWithMutex(1, 0, delay),
      account.depositWithMutex(1, 0, delay),
      account.depositWithMutex(1, 0, delay),
      account.depositWithMutex(1, 0, delay),
      account.depositWithMutex(1, 0, delay),
      account.depositWithMutex(1, 0, delay),
      account.depositWithMutex(1, 0, delay),
    ]);
    expect(account.balance, equals(10));
  });

  group('withLock', () {
    test('lock obtained and released on success', () async {
      // This is the normal scenario of the critical section running
      // successfully. The lock is acquired before running the critical
      // section, and it is released after it runs (and will remain
      // unlocked after the _protect_ method returns).

      final m = Mutex();

      await m.withLock(() async {
        // critical section: returns Future<void>
        expect(m.isLocked, isTrue);
      });

      expect(m.isLocked, isFalse);
    });

    test('value returned from critical section', () async {
      // These are the normal scenario of the critical section running
      // successfully. It tests different return types from the
      // critical section.

      final m = Mutex();

      // returns Future<void>
      await m.withLock<void>(() async {});

      // returns Future<int>
      final number = await m.withLock<int>(() async => 42);
      expect(number, equals(42));

      // returns Future<int?> completes with value
      final optionalNumber = await m.withLock<int?>(() async => 1024);
      expect(optionalNumber, equals(1024));

      // returns Future<int?> completes with null
      final optionalNumberNull = await m.withLock<int?>(() async => null);
      expect(optionalNumberNull, isNull);

      // returns Future<String>
      final word = await m.withLock<String>(() async => 'foobar');
      expect(word, equals('foobar'));

      // returns Future<String?> completes with value
      final optionalWord = await m.withLock<String?>(() async => 'baz');
      expect(optionalWord, equals('baz'));

      // returns Future<String?> completes with null
      final optionalWordNull = await m.withLock<String?>(() async => null);
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

      final m = Mutex();

      try {
        // Invoke protect to get the Future (this should succeed)
        final resultFuture = m.withLock<int>(criticalSection);
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

      final m = Mutex();

      try {
        // Invoke protect to get the Future (this should succeed)
        final resultFuture = m.withLock<int>(criticalSection);
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
