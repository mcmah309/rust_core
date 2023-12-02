import 'package:rust_core/cell.dart';

/// A value which is initialized on the first access. Const Non-nullable implementation of [LazyCell]
class ConstNonNullableLazyCell<T extends Object> implements LazyCell<T>{
  static final _cache = Expando();
  final T Function() _func;
  /// Const objects all share the same canonicalization, meaning instantiation of the same class with the same arguments
  /// will be the same instance. Therefore, if you need multiple const versions, an [id] is needed.
  final Object id;

  const ConstNonNullableLazyCell(this._func,this.id);

  @override
  T call() {
    T? result = _cache[this] as T?;
    if (result != null) return result;
    result = _func();
    _cache[this] = result;
    return result;
  }

  @override
  int get hashCode {
    var valueHash = _cache[this]?.hashCode ?? 0;
    return valueHash;
  }

  @override
  bool operator ==(Object other) {
    return other is ConstNonNullableLazyCell
        && runtimeType == other.runtimeType
        && _cache[this] == _cache[other];
  }

  @override
  String toString(){
    T? cacheResult = _cache[this] as T?;
    String initializedState;
    if(cacheResult == null){
      initializedState = "Uninitialized ";
    }
    else{
      initializedState = "Initialized ";
    }
    return initializedState + runtimeType.toString();
  }
}

/// A value which is initialized on the first access. Nullable implementation of [LazyCell]
class ConstNullableLazyCell<T> implements NullableLazyCell<T>{
  static final _cache = Expando();
  final T Function() _func;
  /// Const objects all share the same canonicalization, meaning instantiation of the same class with the same arguments
  /// will be the same instance. Therefore, if you need multiple const versions, an [id] is needed.
  final Object id;

  const ConstNullableLazyCell(this._func, this.id);

  @override
  T call() {
    (T,)? cacheResult = _cache[this] as (T,)?;
    if (cacheResult != null) return cacheResult.$1;
    T funcResult = _func();
    _cache[this] = (funcResult,);
    return funcResult;
  }

  @override
  int get hashCode {
    var valueHash = _cache[this]?.hashCode ?? 0;
    return valueHash;
  }

  @override
  bool operator ==(Object other) {
    return other is ConstNullableLazyCell && runtimeType == other.runtimeType && _cache[this] == _cache[other];
  }

  @override
  String toString(){
    (T,)? cacheResult = _cache[this] as (T,)?;
    String initializedState;
    if(cacheResult == null){
      initializedState = "Uninitialized ";
    }
    else{
      initializedState = "Initialized ";
    }
    return initializedState + runtimeType.toString();
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

  @override
  int get hashCode {
    final valueHash = _val?.hashCode ?? 0;
    return valueHash;
  }

  @override
  bool operator ==(Object other) {
    return other is NonNullableLazyCell
        && runtimeType == other.runtimeType
        && _val == other._val;
  }

  @override
  String toString(){
    return (_val == null ? "Uninitialized " : "Initialized ") + runtimeType.toString();
  }
}