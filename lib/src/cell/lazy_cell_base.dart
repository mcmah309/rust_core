import 'package:rust_core/cell.dart';

/// A value which is initialized on the first access.
///
/// Equality: Cells are equal if they have the same value and are the same runtime Type.
///
/// Hash: Cells hash to their evaluated or unevaluated value
abstract interface class LazyCell<T extends Object>
    implements NullableLazyCell<T> {
  factory LazyCell(T Function() func) = NonNullableLazyCell;

  const factory LazyCell.constant(T Function() func, Object id) =
      ConstNonNullableLazyCell;
}

/// A value which is initialized on the first access. Nullable implementation of [LazyCell]
///
/// Equality: Cells are equal if they have the same value and are the same runtime Type.
///
/// Hash: Cells hash to their evaluated or unevaluated value
class NullableLazyCell<T> {
  late final T _val;
  final T Function() _func;
  bool _isSet = false;

  NullableLazyCell(this._func);

  /// Lazily evaluates the function passed into the constructor.
  T call() {
    if (_isSet) {
      return _val!;
    }
    _isSet = true;
    _val = _func();
    return _val;
  }

  @override
  int get hashCode {
    final valueHash = _isSet ? _val.hashCode : 0;
    return valueHash;
  }

  @override
  bool operator ==(Object other) {
    return other is NullableLazyCell &&
        runtimeType == other.runtimeType &&
        _val == other._val;
  }

  @override
  String toString() {
    return (_isSet ? "Initialized " : "Uninitialized ") +
        runtimeType.toString();
  }
}
