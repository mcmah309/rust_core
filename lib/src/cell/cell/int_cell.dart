part of 'cell.dart';

extension IntConstCellExtensions on ConstCell<int> {
  Cell<int> operator +(ConstCell<int> other) {
    return Cell<int>(_val + other._val);
  }

  Cell<int> operator -(ConstCell<int> other) {
    return Cell<int>(_val - other._val);
  }

  Cell<int> operator *(ConstCell<int> other) {
    return Cell<int>(_val * other._val);
  }

  /// Performs integer division of this object.
  Cell<int> operator ~/(ConstCell<int> other) {
    return Cell<int>(_val ~/ other._val);
  }

  Cell<int> operator %(ConstCell<int> other) {
    return Cell<int>(_val % other._val);
  }

  Cell<int> operator -() {
    return Cell<int>(-_val);
  }

  bool operator <(ConstCell<int> other) {
    return _val < other._val;
  }

  /// Less than
  bool lt(int val) {
    return _val < val;
  }

  bool operator >(ConstCell<int> other) {
    return _val > other._val;
  }

  /// Greater than
  bool gt(int val) {
    return _val > val;
  }

  bool operator <=(ConstCell<int> other) {
    return _val <= other._val;
  }

  /// Less than or equal to
  bool lte(int val) {
    return _val <= val;
  }

  bool operator >=(ConstCell<int> other) {
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

extension IntCellExtensions on Cell<int> {
  /// Add
  void add(int val) {
    _val = _val + val;
  }

  /// Subtract
  void sub(int val) {
    _val = _val - val;
  }

  /// Multiply
  void mul(int val) {
    _val = _val * val;
  }

  /// Performs integer division of this object. Truncate Divide
  void truncDiv(int val) {
    _val = _val ~/ val;
  }

  /// Modulo
  void mod(int val) {
    _val = _val % val;
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
}
