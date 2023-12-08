part of 'cell.dart';

extension IntCellExtensions on Cell<int> {
  Cell<int> operator +(Cell<int> other) {
    return Cell<int>(_val + other._val);
  }

  /// Add
  void add(int val) {
    _val = _val + val;
  }

  Cell<int> operator -(Cell<int> other) {
    return Cell<int>(_val - other._val);
  }

  /// Subtract
  void sub(int val) {
    _val = _val - val;
  }

  Cell<int> operator *(Cell<int> other) {
    return Cell<int>(_val * other._val);
  }

  /// Multiply
  void mul(int val) {
    _val = _val * val;
  }

  /// Performs integer division of this object.
  Cell<int> operator ~/(Cell<int> other) {
    return Cell<int>(_val ~/ other._val);
  }

  /// Performs integer division of this object. Truncate Divide
  void truncDiv(int val) {
    _val = _val ~/ val;
  }

  Cell<int> operator %(Cell<int> other) {
    return Cell<int>(_val % other._val);
  }

  /// Modulo
  void mod(int val) {
    _val = _val % val;
  }

  Cell<int> operator -() {
    return Cell<int>(-_val);
  }

  /// Negate
  void neg() {
    _val = -_val;
  }

  /// Increment
  void inc() {
    _val = _val + 1;
  }

  /// Decrement
  void dec() {
    _val = _val - 1;
  }

  bool operator <(Cell<int> other) {
    return _val < other._val;
  }

  /// Less than
  bool lt(int val) {
    return _val < val;
  }

  bool operator >(Cell<int> other) {
    return _val > other._val;
  }

  /// Greater than
  bool gt(int val) {
    return _val > val;
  }

  bool operator <=(Cell<int> other) {
    return _val <= other._val;
  }

  /// Less than or equal to
  bool lte(int val) {
    return _val <= val;
  }

  bool operator >=(Cell<int> other) {
    return _val >= other._val;
  }

  /// Greater than or equal to
  bool gte(int val) {
    return _val >= val;
  }

  /// Equal to
  bool eq(int val) {
    return _val == val;
  }
}
