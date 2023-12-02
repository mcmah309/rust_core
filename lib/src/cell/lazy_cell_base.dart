import 'package:rust_core/cell.dart';

/// A value which is initialized on the first access.
abstract interface class LazyCell<T extends Object> implements NullableLazyCell<T> {
  factory LazyCell(T Function() func) = NonNullableLazyCell;

  const factory LazyCell.constant(T Function() func) = ConstNonNullableLazyCell;
}

/// A value which is initialized on the first access. Nullable implementation of [LazyCell]
class NullableLazyCell<T> {
  late final T _val;
  final T Function() _func;
  bool _isSet = false;

  NullableLazyCell(this._func);

  /// Lazily evaluates the function passed into the constructor.
  T call() {
    if(_isSet){
      return _val!;
    }
    _isSet = true;
    _val = _func();
    return _val;
  }
}