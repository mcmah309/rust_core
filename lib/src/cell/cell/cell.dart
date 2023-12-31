part 'const_cell.dart';
part 'int_cell.dart';
part 'double_cell.dart';
part 'bool_cell.dart';
part 'string_cell.dart';

/// A mutable container. Useful for primitives.
class Cell<T> implements ConstCell<T> {
  @override
  T _val;

  Cell(T val) : _val = val;

  /// Returns the inner value.
  @override
  T get() {
    return _val;
  }

  /// Replaces the inner value with the provided [val] and returns the original inner value.
  T replace(T val) {
    final temp = _val;
    _val = val;
    return temp;
  }

  /// Sets the inner value to [val].
  void set(T val) {
    _val = val;
  }

  /// swaps the inner values between this cell and that [cell].
  void swap(covariant Cell<T> cell) {
    final temp = cell._val;
    cell._val = _val;
    _val = temp;
  }

  /// Updates the contained value using [fn] and returns the new value
  T update(T Function(T) fn) {
    _val = fn(_val);
    return _val;
  }

  /// Shallow copy of this [Cell].
  @override
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
