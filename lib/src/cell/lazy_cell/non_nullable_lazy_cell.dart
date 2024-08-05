import 'package:rust_core/cell.dart';

/// A value which is initialized on the first access. Non-nullable implementation of [LazyCell]
///
/// Equality: Cells are equal if they have the same evaluated value or are unevaluated.
///
/// Hash: Cells hash to their evaluated value or hash the same if unevaluated.
class NonNullableLazyCell<T extends Object> implements LazyCell<T> {
  T? _val;
  final T Function() _func;

  NonNullableLazyCell(this._func);

  @override
  @pragma("vm:prefer-inline")
  T force() => call();

  @override
  @pragma("vm:prefer-inline")
  T call() {
    if (_val == null) {
      _val = _func();
      return _val!;
    }
    return _val!;
  }

  @override
  @pragma("vm:prefer-inline")
  bool isEvaluated() {
    return _val == null ? false : true;
  }

  @override
  int get hashCode {
    final valueHash = _val?.hashCode ?? 0;
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
    return (_val == null
        ? "Uninitialized $runtimeType"
        : "Initialized $runtimeType($_val)");
  }
}
