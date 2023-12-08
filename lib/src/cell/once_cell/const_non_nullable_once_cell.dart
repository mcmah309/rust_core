import 'package:rust_core/cell.dart';

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
  Option<T> get() {
    final val = _cache[this] as T?;
    if (val == null) {
      return const None();
    }
    return Some(val);
  }

  @override
  T? getOrNull() {
    return get().toNullable();
  }

  @override
  T getOrInit(T Function() func) {
    var val = _cache[this] as T?;
    if (val != null) {
      return val;
    }
    val = func();
    _cache[this] = val;
    return val;
  }

  @override
  Result<T, E> getOrTryInit<E extends Object>(Result<T, E> Function() f) {
    var val = _cache[this] as T?;
    if (val != null) {
      return Ok(val);
    }
    final result = f();
    if (result.isOk()) {
      final val = result.unwrap();
      _cache[this] = val;
      return Ok(val);
    }
    return result;
  }

  @override
  T? setOrNull(T value) {
    var val = _cache[this] as T?;
    if (val != null) {
      return null;
    }
    _cache[this] = value;
    return value;
  }

  @override
  Result<(), T> set(T value) {
    var val = _cache[this] as T?;
    if (val != null) {
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
  Option<T> take() {
    var val = _cache[this] as T?;
    if (val != null) {
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
    return other is ConstNonNullableOnceCell &&
        runtimeType == other.runtimeType &&
        _cache[this] == _cache[other];
  }

  @override
  String toString() {
    T? cacheResult = _cache[this] as T?;
    String initializedState;
    if (cacheResult == null) {
      initializedState = "Uninitialized ";
    } else {
      initializedState = "Initialized ";
    }
    return initializedState + runtimeType.toString();
  }
}