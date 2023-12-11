part of 'cell.dart';

/// A constant container.
class ConstCell<T> {
  final T _val;

  const ConstCell(this._val);

  /// Shallow copy of this.
  Cell<T> copy() {
    return Cell(_val);
  }

  /// Returns the inner value.
  T get() {
    return _val;
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
