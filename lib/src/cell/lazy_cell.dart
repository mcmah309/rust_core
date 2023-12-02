import 'package:rust_core/cell.dart';

/// A value which is initialized on the first access. Const Non-nullable implementation of [LazyCell]
class ConstNonNullableLazyCell<T extends Object> implements LazyCell<T>{
  static final _cache = Expando();
  final T Function() _func;

  const ConstNonNullableLazyCell(this._func);

  @override
  T call() {
    T? result = _cache[this] as T?;
    if (result != null) return result;
    result = _func();
    _cache[this] = result;
    return result;
  }
}

/// A value which is initialized on the first access. Nullable implementation of [LazyCell]
class ConstNullableLazyCell<T> implements NullableLazyCell<T>{
  static final _cache = Expando();
  final T Function() _func;

  const ConstNullableLazyCell(this._func);

  @override
  T call() {
    (T,)? cacheResult = _cache[this] as (T,)?;
    if (cacheResult != null) return cacheResult.$1;
    T funcResult = _func();
    _cache[this] = (funcResult);
    return funcResult;
  }
}

/// A value which is initialized on the first access. Non-nullable implementation of [LazyCell]
class NonNullableLazyCell<T extends Object> implements LazyCell<T> {
  T? _val;
  final T Function() _func;

  NonNullableLazyCell(this._func);

  @override
  T call() {
    if(_val == null){
      _val = _func();
      return _val!;
    }
    return _val!;
  }
}