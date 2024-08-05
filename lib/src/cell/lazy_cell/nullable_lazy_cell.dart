import 'package:rust_core/cell.dart';

/// A value which is initialized on the first access. Nullable implementation of [LazyCell]
///
/// Equality: Cells are equal if they have the same evaluated value or are unevaluated.
///
/// Hash: Cells hash to their evaluated value or hash the same if unevaluated.
class NullableLazyCell<T> {
  late final T _val;
  final T Function() _func;
  bool _isSet = false;

  NullableLazyCell(this._func);

  /// Lazily evaluates the function passed into the constructor.
  @pragma("vm:prefer-inline")
  T force() => call();

  /// Lazily evaluates the function passed into the constructor.
  T call() {
    if (_isSet) {
      return _val!;
    }
    _isSet = true;
    _val = _func();
    return _val;
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
    return other is NullableLazyCell &&
        ((isEvaluated() && other.isEvaluated() && this() == other()) ||
            (!isEvaluated() && !other.isEvaluated()));
  }

  @override
  String toString() {
    return (_isSet
        ? "Initialized $runtimeType($_val)"
        : "Uninitialized $runtimeType");
  }
}
