import 'package:rust_core/cell.dart';

/// A value which is initialized on the first access. Non-nullable implementation of [LazyCell]
///
/// Equality: Cells are equal if they are [NonNullableLazyCell] and have the same evaluated value or are unevaluated.
///
/// Hash: Cells hash to their evaluated value or hash the same if unevaluated.
class NonNullableLazyCell<T extends Object> implements LazyCell<T> {
  T? _val;
  final T Function() _func;

  NonNullableLazyCell(this._func);

  @override
  T call() {
    if (_val == null) {
      _val = _func();
      return _val!;
    }
    return _val!;
  }

  @override
  int get hashCode {
    final valueHash = _val?.hashCode ?? 0;
    return valueHash;
  }

  @override
  bool operator ==(Object other) {
    return other is NonNullableLazyCell && _val == other._val;
  }

  @override
  String toString() {
    return (_val == null ? "Uninitialized " : "Initialized ") +
        runtimeType.toString();
  }
}
