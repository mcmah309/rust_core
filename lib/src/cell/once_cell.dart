import 'package:rust_core/cell.dart';
import 'package:rust_core/option.dart';
import 'package:rust_core/result.dart';



/// OnceCell, A cell which can be written to only once. OnceCell implementation that allows [T] to be null, does not
/// use [Option], and has a const constructor.
///
/// Equality: Cells are equal if they have the same value and are the same runtime Type.
///
/// Hash: Cells hash to their existing or non-existing value
class ConstNullableOnceCell<T> implements NullableOnceCell<T> {
  static final _cache = Expando();
  /// Const objects all share the same canonicalization, meaning instantiation of the same class with the same arguments
  /// will be the same instance. Therefore, if you need multiple const versions, an [id] is needed.
  final Object id;

  const ConstNullableOnceCell(this.id);

  @override
  T? getOrNull(){
    final val = _cache[this] as (T,)?;
    if(val == null){
      return null;
    }
    return val.$1;
  }

  @override
  T getOrInit(T Function() func){
    var val = _cache[this] as (T,)?;
    if(val != null){
      return val.$1;
    }
    val = (func(),);
    _cache[this] = val;
    return val.$1;
  }

  @override
  Result<T,E> getOrTryInit<E extends Object>(Result<T,E> Function() f){
    var val = _cache[this] as (T,)?;
    if(val != null){
      return Ok(val.$1);
    }
    final result = f();
    if(result.isOk()){
      final val = result.unwrap();
      _cache[this] = (val,);
      return Ok(val);
    }
    return result;
  }

  @override
  T? setOrNull(T value) {
    var val = _cache[this] as (T,)?;
    if(val != null){
      return null;
    }
    _cache[this] = (value,);
    return value;
  }

  @override
  T? takeOrNull() {
    var val = _cache[this] as (T,)?;
    if(val != null){
      _cache[this] = null;
      return val.$1;
    }
    return null;
  }

  @override
  int get hashCode {
    var valueHash = _cache[this]?.hashCode ?? 0;
    return valueHash;
  }

  @override
  bool operator ==(Object other) {
    return other is ConstNullableOnceCell && runtimeType == other.runtimeType && _cache[this] == _cache[other];
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

//************************************************************************//

/// OnceCell, A cell which can be written to only once.
///
/// Equality: Cells are equal if they have the same value and are the same runtime Type.
///
/// Hash: Cells hash to their existing or non-existing value
abstract interface class OnceCell<T extends Object> implements NullableOnceCell<T> {

  factory OnceCell() = NonNullableOnceCell;

  const factory OnceCell.constant(Object id) = ConstNonNullableOnceCell;

  factory OnceCell.withValue(T val) = NonNullableOnceCell.withValue;

  /// Gets the reference to the underlying value.
  Option<T> get();

  /// Sets the contents of the cell to value.
  Result<(),T> set(T value);

  /// Takes the value out of this OnceCell, moving it back to an uninitialized state.
  Option<T> take();
}

/// OnceCell, A cell which can be written to only once. OnceCell implementation based off [Option] with a const
/// constructor
///
/// Equality: Cells are equal if they have the same value and are the same runtime Type.
///
/// Hash: Cells hash to their existing or non-existing value
class ConstNonNullableOnceCell<T extends Object> implements OnceCell<T> {
  static final _cache = Expando();
  /// Const objects all share the same canonicalization, meaning instantiation of the same class with the same arguments
  /// will be the same instance. Therefore, if you need multiple const versions, an [id] is needed.
  final Object id;

  const ConstNonNullableOnceCell(this.id);

  @override
  Option<T> get(){
    final val = _cache[this] as T?;
    if(val == null){
      return const None();
    }
    return Some(val);
  }

  @override
  T? getOrNull(){
    return get().toNullable();
  }

  @override
  T getOrInit(T Function() func){
    var val = _cache[this] as T?;
    if(val != null){
      return val;
    }
    val = func();
    _cache[this] = val;
    return val;
  }

  @override
  Result<T,E> getOrTryInit<E extends Object>(Result<T,E> Function() f){
    var val = _cache[this] as T?;
    if(val != null){
      return Ok(val);
    }
    final result = f();
    if(result.isOk()){
      final val = result.unwrap();
      _cache[this] = val;
      return Ok(val);
    }
    return result;
  }

  @override
  T? setOrNull(T value) {
    var val = _cache[this] as T?;
    if(val != null){
      return null;
    }
    _cache[this] = value;
    return value;
  }

  @override
  Result<(),T> set(T value){
    var val = _cache[this] as T?;
    if(val != null){
      return Err(value);
    }
    _cache[this] = value;
    return const Ok(());
  }

  @override
  T? takeOrNull() {
    return take().toNullable();
  }

  @override
  Option<T> take(){
    var val = _cache[this] as T?;
    if(val != null){
      _cache[this] = null;
      return Some(val);
    }
    return const None();
  }

  @override
  int get hashCode {
    var valueHash = _cache[this]?.hashCode ?? 0;
    return valueHash;
  }

  @override
  bool operator ==(Object other) {
    return other is ConstNonNullableOnceCell
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

/// OnceCell, A cell which can be written to only once. OnceCell implementation based off [Option]
///
/// Equality: Cells are equal if they have the same value and are the same runtime Type.
///
/// Hash: Cells hash to their existing or non-existing value
class NonNullableOnceCell<T extends Object> implements OnceCell<T> {
  T? _val;

  NonNullableOnceCell();

  NonNullableOnceCell.withValue(this._val);


  @override
  Option<T> get(){
    if(_val == null){
      return const None();
    }
    return Some(_val!);
  }

  @override
  T? getOrNull(){
    return get().toNullable();
  }

  @override
  T getOrInit(T Function() func){
    if(_val != null){
      return _val!;
    }
    _val = func();
    return _val!;
  }

  @override
  Result<T,E> getOrTryInit<E extends Object>(Result<T,E> Function() f){
    if(_val != null){
      return Ok(_val!);
    }
    final result = f();
    if(result.isOk()){
      _val = result.unwrap();
      return Ok(_val!);
    }
    return result;
  }

  @override
  T? setOrNull(T value) {
    if(_val != null){
      return null;
    }
    _val = value;
    return value;
  }

  @override
  Result<(),T> set(T value) {
    if(_val != null){
      return Err(value);
    }
    _val = value;
    return const Ok(());
  }

  @override
  T? takeOrNull() {
    return take().toNullable();
  }

  @override
  Option<T> take(){
    if(_val == null){
      return const None();
    }
    final val = _val;
    _val = null;
    return Some(val!);
  }

  @override
  int get hashCode {
    final valueHash = _val?.hashCode ?? 0;
    return valueHash;
  }

  @override
  bool operator ==(Object other) {
    return other is NonNullableOnceCell
        && runtimeType == other.runtimeType
        && _val == other._val;
  }

  @override
  String toString(){
    return (_val == null ? "Uninitialized " : "Initialized ") + runtimeType.toString();
  }
}