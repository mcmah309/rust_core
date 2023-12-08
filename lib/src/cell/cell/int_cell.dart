part of 'cell.dart';

extension IntCellExtensions on Cell<int> {
  Cell<int> operator +(Cell<int> other) {
    return Cell<int>(_val + other._val);
  }

  void add(int val) {
    _val = _val + val;
  }

  Cell<int> operator -(Cell<int> other) {
    return Cell<int>(_val - other._val);
  }

  void subtract(int val) {
    _val = _val - val;
  }

  Cell<int> operator *(Cell<int> other) {
    return Cell<int>(_val * other._val);
  }

  void multiply(int val) {
    _val = _val * val;
  }

  /// Performs integer division of this object.
  Cell<int> operator ~/(Cell<int> other) {
    return Cell<int>(_val ~/ other._val);
  }

  /// Performs integer division of this object.
  void truncDivide(int val) {
    _val = _val ~/ val;
  }

  Cell<int> operator %(Cell<int> other) {
    return Cell<int>(_val % other._val);
  }

  void modulo(int val) {
    _val = _val % val;
  }

  Cell<int> operator -() {
    return Cell<int>(-_val);
  }

  void negate() {
    _val = -_val;
  }

  void increment() {
    _val = _val + 1;
  }

  void decrement() {
    _val = _val - 1;
  }

  bool operator <(Cell<int> other) {
    return _val < other._val;
  }

  bool lt(int val) {
    return _val < val;
  }

  bool operator >(Cell<int> other) {
    return _val > other._val;
  }

  bool gt(int val) {
    return _val > val;
  }

  bool operator <=(Cell<int> other) {
    return _val <= other._val;
  }

  bool lte(int val) {
    return _val <= val;
  }

  bool operator >=(Cell<int> other) {
    return _val >= other._val;
  }

  bool gte(int val) {
    return _val >= val;
  }

  bool eq(int val) {
    return _val == val;
  }
}
