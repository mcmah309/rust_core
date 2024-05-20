import 'dart:async';

part 'rw_lock.dart';

/// Mutual exclusion.
///
/// The [withLock] method is a convenience method for acquiring a lock before
/// running critical code, and then releasing the lock afterwards. Using this
/// convenience method will ensure the lock is always released after use.
///
/// Usage:
///
///     m = Mutex();
///
///     await m.withLock(() async {
///       // critical section
///     });
///
/// Alternatively, a lock can be explicitly acquired and managed. In this
/// situation, the program is responsible for releasing the lock after it
/// have been used. Failure to release the lock will prevent other code for
/// ever acquiring the lock.
///
///     m = Mutex();
///
///     await m.lock();
///     try {
///       // critical section
///     }
///     finally {
///       m.release();
///     }
class Mutex {
  // Implemented as a ReadWriteMutex that is used only with write locks.
  final RwLock _rwMutex = RwLock();

  /// Indicates if a lock has been acquired and not released.
  bool get isLocked => (_rwMutex.isLocked);

  /// Acquire a lock
  ///
  /// Returns a future that will be completed when the lock has been acquired.
  ///
  /// Consider using the convenience method [withLock], otherwise the caller
  /// is responsible for making sure the lock is released after it is no longer
  /// needed. Failure to release the lock means no other code can acquire the
  /// lock.
  Future lock() => _rwMutex.write();

  /// Release a lock.
  ///
  /// Release a lock that has been acquired.
  void release() => _rwMutex.release();

  /// Convenience method for protecting a function with a lock.
  ///
  /// This method guarantees a lock is always acquired before invoking the
  /// [criticalSection] function. It also guarantees the lock is always
  /// released.
  ///
  /// A critical section should always contain asynchronous code, since purely
  /// synchronous code does not need to be protected inside a critical section.
  /// Therefore, the critical section is a function that returns a _Future_.
  /// If the critical section does not need to return a value, it should be
  /// defined as returning `Future<void>`.
  ///
  /// Returns a _Future_ whose value is the value of the _Future_ returned by
  /// the critical section.
  ///
  /// An exception is thrown if the critical section throws an exception,
  /// or an exception is thrown while waiting for the _Future_ returned by
  /// the critical section to complete. The lock is released, when those
  /// exceptions occur.
  Future<T> withLock<T>(Future<T> Function() criticalSection) async {
    await lock();
    try {
      return await criticalSection();
    } finally {
      release();
    }
  }
}
