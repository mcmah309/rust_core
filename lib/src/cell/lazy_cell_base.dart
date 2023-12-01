import 'lazy_cell.dart';

abstract interface class LazyCell<T extends Object> implements NullableLazyCell<T> {
  const factory LazyCell(T Function() func) = ConstNonNullableLazyCell;
}

class NullableLazyCell<T> {
  late final T _val;
  final T Function() _func;
  bool _isSet = false;

  NullableLazyCell(this._func);

  @override
  T call() {
    if(_isSet){
      return _val!;
    }
    _isSet = true;
    _val = _func();
    return _val;
  }
}