import '../../rust_core.dart';

/// OnceCell, A cell which can be written to only once. OnceCell implementation that allows [T] to be null and does
/// not use [Option]
class NullableOnceCell<T> {
  T? _val;
  bool _isSet = false;

  NullableOnceCell();

  NullableOnceCell.withValue(this._val): _isSet = true;

  /// Gets the underlying value, returns null if the cell is empty
  T? getOrNull(){
    return _val;
  }

  /// Gets the contents of the cell, initializing it with [func] if the cell was empty.
  T getOrInit(T Function() func){
    if(_isSet){
      return _val!;
    }
    _val = func();
    _isSet = true;
    return _val!;
  }

  /// Gets the contents of the cell, initializing it with f if the cell was empty. If the cell was empty and f failed, an error is returned.
  Result<T,E> getOrTryInit<E extends Object>(Result<T,E> Function() f){
    if(_isSet){
      return Ok(_val as T);
    }
    final result = f();
    if(result.isOk()){
      _val = result.unwrap();
      _isSet = true;
      return Ok(_val as T);
    }
    return result;
  }

  /// Sets the contents of the cell to value. Returns null if the value is already set.
  T? setOrNull(T value){
    if(_isSet){
      return null;
    }
    _val = value;
    _isSet = true;
    return _val;
  }

  /// Takes the value out of this OnceCell, moving it back to an uninitialized state. Returns null if the cell is empty.
  T? takeOrNull(){
    if(_isSet){
      _isSet = false;
      return _val;
    }
    return null;
  }
}