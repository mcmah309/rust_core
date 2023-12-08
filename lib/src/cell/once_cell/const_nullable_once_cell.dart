import 'package:rust_core/cell.dart';

/// OnceCell, A cell which can be written to only once. OnceCell implementation that allows [T] to be null, does not
/// use [Option], and has a const constructor.
///
/// Equality: Cells are equal if they have the same inner value and are [ConstNullableOnceCell].
///
/// Hash: Cells hash to their existing or non-existing value
class ConstNullableOnceCell<T> implements NullableOnceCell<T> {
  static final _cache = Expando();

  /// Const objects all share the same canonicalization, meaning instantiation of the same class with the same arguments
  /// will be the same instance. Therefore, if you need multiple const versions, an [id] is needed.
  final Object id;

  const ConstNullableOnceCell(this.id);

  @override
  T? getOrNull() {
    final val = _cache[this] as (T,)?;
    if (val == null) {
      return null;
    }
    return val.$1;
  }

  @override
  T getOrInit(T Function() func) {
    var val = _cache[this] as (T,)?;
    if (val != null) {
      return val.$1;
    }
    val = (func(),);
    _cache[this] = val;
    return val.$1;
  }

  @override
  Result<T, E> getOrTryInit<E extends Object>(Result<T, E> Function() f) {
    var val = _cache[this] as (T,)?;
    if (val != null) {
      return Ok(val.$1);
    }
    final result = f();
    if (result.isOk()) {
      final val = result.unwrap();
      _cache[this] = (val,);
      return Ok(val);
    }
    return result;
  }

  @override
  T? setOrNull(T value) {
    var val = _cache[this] as (T,)?;
    if (val != null) {
      return null;
    }
    _cache[this] = (value,);
    return value;
  }

  @override
  T? takeOrNull() {
    var val = _cache[this] as (T,)?;
    if (val != null) {
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
    return other is ConstNullableOnceCell && _cache[this] == _cache[other];
  }

  @override
  String toString() {
    (T,)? cacheResult = _cache[this] as (T,)?;
    String initializedState;
    if (cacheResult == null) {
      initializedState = "Uninitialized ";
    } else {
      initializedState = "Initialized ";
    }
    return initializedState + runtimeType.toString();
  }
}
