part 'const_cell.dart';
part 'int_cell.dart';
part 'double_cell.dart';
part 'bool_cell.dart';
part 'string_cell.dart';

/// A wrapper with interior mutability. Useful for primitives and an escape hatch for working with immutable data patterns.
class Cell<T> implements ConstCell<T> {
  @override
  T _val;

  Cell(T val) : _val = val;

  /// Returns the inner value.
  @override
  @pragma("vm:prefer-inline")
  T get() {
    return _val;
  }

  /// Replaces the inner value with the provided [val] and returns the original inner value.
  @pragma("vm:prefer-inline")
  T replace(T val) {
    final temp = _val;
    _val = val;
    return temp;
  }

  /// Sets the inner value to [val].
  @pragma("vm:prefer-inline")
  void set(T val) {
    _val = val;
  }

  /// swaps the inner values between this cell and that [cell].
  @pragma("vm:prefer-inline")
  void swap(covariant Cell<T> cell) {
    final temp = cell._val;
    cell._val = _val;
    _val = temp;
  }

  /// Updates the contained value using [fn] and returns the new value
  @pragma("vm:prefer-inline")
  T update(T Function(T) fn) {
    _val = fn(_val);
    return _val;
  }

  /// Shallow copy of this [Cell].
  @override
  @pragma("vm:prefer-inline")
  Cell<T> copy() {
    return Cell(_val);
  }

  @override
  int get hashCode => _val.hashCode;

  @override
  bool operator ==(covariant Object other) {
    return other is ConstCell && other._val == _val;
  }

  @override
  String toString() {
    return "$runtimeType($_val)";
  }
}
