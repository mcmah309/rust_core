import 'package:rust_core/cell.dart';
import 'package:rust_core/panic.dart';

/// A value which is asynchronously initialized on the first access. Nullable implementation of [AsyncLazyCell]
///
/// Equality: Cells are equal if they have the same evaluated value or are unevaluated.
///
/// Hash: Cells hash to their evaluated value or hash the same if unevaluated.
class AsyncNullableLazyCell<T> {
  late final T _val;
  final Future<T> Function() _func;
  bool _isSet = false;

  AsyncNullableLazyCell(this._func);

  @pragma("vm:prefer-inline")
  Future<T> force() async {
    if (_isSet) {
      return _val!;
    }
    _isSet = true;
    _val = await _func();
    return _val;
  }

  /// Returns the previously evaluated asynchronous value of the function passed into the constructor. Will panic
  /// if the value has not yet been evaluated. Prefer [force] for safer context.
  @pragma("vm:prefer-inline")
  T call() {
    if (!_isSet) {
      panic(
          "Cannot get the result of an async LazyCell synchronously if the value has not yet been computed asynchronously.");
    }
    return _val!;
  }

  /// Returns true if this has already been called, otherwise false.
  @pragma("vm:prefer-inline")
  bool isEvaluated() {
    return _isSet;
  }

  @override
  int get hashCode {
    final valueHash = _isSet ? _val.hashCode : 0;
    return valueHash;
  }

  @override
  bool operator ==(Object other) {
    return other is AsyncNullableLazyCell &&
        ((isEvaluated() && other.isEvaluated() && this() == other()) ||
            (!isEvaluated() && !other.isEvaluated()));
  }

  @override
  String toString() {
    return (_isSet ? "Initialized $runtimeType($_val)" : "Uninitialized $runtimeType");
  }
}
