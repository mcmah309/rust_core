import '../../rust_core.dart';
import 'once_cell_base.dart';


/// OnceCell, A cell which can be written to only once. OnceCell implementation that allows [T] to be null, does not
/// use [Option], and has a const constructor.
class ConstNullableOnceCell<T> implements NullableOnceCell<T> {
  static final _cache = Expando();

  const ConstNullableOnceCell();

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
}

//************************************************************************//

/// OnceCell, A cell which can be written to only once.
abstract interface class OnceCell<T extends Object> implements NullableOnceCell<T> {

  factory OnceCell() = NonNullableOnceCell;

  const factory OnceCell.constant() = ConstNonNullableOnceCell;

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
class ConstNonNullableOnceCell<T extends Object> implements OnceCell<T> {
  static final _cache = Expando();

  const ConstNonNullableOnceCell();

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
}

/// OnceCell, A cell which can be written to only once. OnceCell implementation based off [Option]
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
    return Some(_val!);
  }
}