import 'package:rust_core/cell.dart';

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
  Option<T> get() {
    if (_val == null) {
      return const None();
    }
    return Some(_val!);
  }

  @override
  T? getOrNull() {
    return get().toNullable();
  }

  @override
  T getOrInit(T Function() func) {
    if (_val != null) {
      return _val!;
    }
    _val = func();
    return _val!;
  }

  @override
  Result<T, E> getOrTryInit<E extends Object>(Result<T, E> Function() f) {
    if (_val != null) {
      return Ok(_val!);
    }
    final result = f();
    if (result.isOk()) {
      _val = result.unwrap();
      return Ok(_val!);
    }
    return result;
  }

  @override
  T? setOrNull(T value) {
    if (_val != null) {
      return null;
    }
    _val = value;
    return value;
  }

  @override
  Result<(), T> set(T value) {
    if (_val != null) {
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
  Option<T> take() {
    if (_val == null) {
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
    return other is NonNullableOnceCell &&
        runtimeType == other.runtimeType &&
        _val == other._val;
  }

  @override
  String toString() {
    return (_val == null ? "Uninitialized " : "Initialized ") +
        runtimeType.toString();
  }
}