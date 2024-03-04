import 'package:rust_core/cell.dart';
import 'package:rust_core/option.dart';
import 'package:rust_core/result.dart';

/// OnceCell, A cell which can be written to only once. OnceCell implementation based off [Option]
///
/// Equality: Cells are equal if they have the same value or are not set.
///
/// Hash: Cells hash to their existing or the same if not set.
class NonNullableOnceCell<T extends Object> implements OnceCell<T> {
  T? _val;

  NonNullableOnceCell();

  NonNullableOnceCell.withValue(this._val);

  @override
  Option<T> get() {
    if (_val == null) {
      return None;
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
      return None;
    }
    final val = _val;
    _val = null;
    return Some(val!);
  }

  @override
  bool isSet() {
    return _val == null ? false : true;
  }

  @override
  int get hashCode {
    final valueHash = _val?.hashCode ?? 0;
    return valueHash;
  }

  @override
  bool operator ==(Object other) {
    return other is NullableOnceCell &&
        ((isSet() && other.isSet() && getOrNull() == other.getOrNull()) ||
            (!isSet() && !other.isSet()));
  }

  @override
  String toString() {
    return (_val == null
        ? "Uninitialized $runtimeType"
        : "Initialized $runtimeType($_val)");
  }
}
