part of "mutex.dart";

/// Internal representation of a request for a lock.
///
/// This is instantiated for each acquire and, if necessary, it is added
/// to the waiting queue.
class _ReadWriteMutexRequest {
  /// Internal constructor.
  ///
  /// The [isRead] indicates if this is a request for a read lock (true) or a
  /// request for a write lock (false).
  _ReadWriteMutexRequest({required this.isRead});

  /// Indicates if this is a read or write lock. true == read lock requested; false == write lock requested.
  final bool isRead;

  /// The job's completer.
  ///
  /// This [Completer] will complete when this mutex has acquired the lock.
  final Completer<void> hasLock = Completer<void>();
}

/// Mutual exclusion that supports read and write locks.
///
/// Multiple read locks can be simultaneously acquired, but at most only
/// one write lock can be acquired at any one time.
///
/// **Protecting critical code**
///
/// The [withWriteLock] and [withReadLock] are convenience methods for acquiring
/// locks and releasing them. Using them will ensure the locks are always
/// released after use.
///
/// Create the mutex:
///
///     m = RwLock();
///
/// Code protected by a write lock:
///
///     await m.withWriteLock(() {
///        // critical write section
///     });
///
/// Other code can be protected by a read lock:
///
///     await m.withReadLock(() {
///         // critical read section
///     });
///
///
/// **Explicitly managing locks**
///
/// Alternatively, the locks can be explicitly acquired and managed. In this
/// situation, the program is responsible for releasing the locks after they
/// have been used. Failure to release the lock will prevent other code for
/// ever acquiring a lock.
///
/// Create the mutex:
///
///     m = RwLock();
///
/// Some code can acquire a write lock:
///
///     await m.write();
///     try {
///       // critical write section
///       assert(m.isWriteLocked);
///     } finally {
///       m.release();
///     }
///
/// Other code can acquire a read lock.
///
///     await m.read();
///     try {
///       // critical read section
///       assert(m.isReadLocked);
///     } finally {
///       m.release();
///     }
///
/// The current implementation lets locks be acquired in first-in-first-out
/// order. This ensures there will not be any lock starvation, which can
/// happen if some locks are prioritized over others.
class RwLock {
  /// List of requests waiting for a lock on this mutex.
  final _waiting = <_ReadWriteMutexRequest>[];

  /// State of the mutex. -1 = write lock, 0 = no lock, else the number of read locks.
  int _state = 0;

  /// Indicates if a lock (read or write) has been acquired and not released.
  bool get isLocked => (_state != 0);

  /// Indicates if a write lock has been acquired and not released.
  bool get isWriteLocked => (_state == -1);

  /// Indicates if one or more read locks has been acquired and not released.
  bool get isReadLocked => (0 < _state);

  /// Acquire a read lock
  ///
  /// Returns a future that will be completed when the lock has been acquired.
  ///
  /// A read lock can not be acquired when there is a write lock on the mutex.
  /// But it can be acquired if there are other read locks.
  ///
  /// Consider using the convenience method [withReadLock], otherwise the caller
  /// is responsible for making sure the lock is released after it is no longer
  /// needed. Failure to release the lock means no other code can acquire a
  /// write lock.
  Future read() => _acquire(isRead: true);

  /// Acquire a write lock
  ///
  /// Returns a future that will be completed when the lock has been acquired.
  ///
  /// A write lock can only be acquired when there are no other locks (neither
  /// read locks nor write locks) on the mutex.
  ///
  /// Consider using the convenience method [withWriteLock], otherwise the caller
  /// is responsible for making sure the lock is released after it is no longer
  /// needed. Failure to release the lock means no other code can acquire the
  /// lock (neither a read lock or a write lock).
  Future write() => _acquire(isRead: false);

  /// Release a lock.
  ///
  /// Release the lock that was previously acquired.
  ///
  /// When the lock is released, locks waiting to be acquired can be acquired
  /// depending on the type of lock waiting and if other locks have been
  /// acquired.
  ///
  /// A [StateError] is thrown if the mutex does not currently have a lock on
  /// it.
  void release() {
    if (_state == -1) {
      // Write lock released
      _state = 0;
    } else if (0 < _state) {
      // Read lock released
      _state--;
    } else if (_state == 0) {
      throw StateError('`release` called when no lock to release.');
    } else {
      assert(false, 'Invalid state. This should not be possible.');
    }

    // If there are jobs waiting and the next job can acquire the mutex,
    // let it acquire it and remove it from the queue.
    //
    // This is a while loop, because there could be multiple jobs on the
    // queue waiting for a read-only mutex. So they can all be allowed to run.
    while (_waiting.isNotEmpty) {
      final nextJob = _waiting.first;
      if (_jobAcquired(nextJob)) {
        _waiting.removeAt(0);
      } else {
        // The next job cannot acquire the mutex. This only occurs when: the
        // the currently running job has a write mutex (_state == -1); or the
        // next job wants write mutex and there is a job currently running
        // (regardless of what type of mutex it has acquired).
        assert(_state < 0 || !nextJob.isRead,
            'unexpected: next job cannot be acquired');
        break; // no more can be removed from the queue
      }
    }
  }

  /// Convenience method for protecting a function with a read lock.
  ///
  /// This method guarantees a read lock is always acquired before invoking the
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
  /// the critical section to complete. The lock is released even when
  /// exceptions occur.
  Future<T> withReadLock<T>(Future<T> Function() criticalSection) async {
    await read();
    try {
      return await criticalSection();
    } finally {
      release();
    }
  }

  /// Convenience method for protecting a function with a write lock.
  ///
  /// This method guarantees a write lock is always acquired before invoking the
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
  /// the critical section to complete. The lock is released even when
  /// exceptions occur.
  Future<T> withWriteLock<T>(Future<T> Function() criticalSection) async {
    await write();
    try {
      return await criticalSection();
    } finally {
      release();
    }
  }

  /// Internal acquire method.
  ///
  /// Used to acquire a read lock (when [isRead] is true) or a write lock
  /// (when [isRead] is false).
  ///
  /// Returns a Future that completes when the lock has been acquired.
  Future<void> _acquire({required bool isRead}) {
    final newJob = _ReadWriteMutexRequest(isRead: isRead);

    if (_waiting.isNotEmpty || !_jobAcquired(newJob)) {
      // This new job cannot run yet. There are either other jobs already
      // waiting, or there are no waiting jobs but this job cannot start
      // because the mutex is currently acquired (namely, either this new job
      // or the currently running job is read-write).
      //
      // Add the new job to the end of the queue.

      _waiting.add(newJob);
    }

    return newJob.hasLock.future;
  }

  /// Determine if the [job] can now acquire the lock.
  ///
  /// If it can acquire the lock, the job's completer is completed, the
  /// state updated, and true is returned. If not, false is returned.
  ///
  /// A job for a read lock can only be acquired if there are no other locks
  /// or there are read lock(s). A job for a write lock can only be acquired
  /// if there are no other locks.
  bool _jobAcquired(_ReadWriteMutexRequest job) {
    assert(-1 <= _state);
    if (_state == 0 || (0 < _state && job.isRead)) {
      // Can acquire
      _state = (job.isRead) ? (_state + 1) : -1;
      job.hasLock.complete();
      return true;
    } else {
      return false;
    }
  }
}
