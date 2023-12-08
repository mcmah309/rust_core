part of 'cell.dart';

class IntCell extends Cell<int> implements _CommonArithmeticOperations<int>, _ComparisonOperations<int>, _UnaryOperations<int> {
  IntCell(super.val);

  @override
  void swap(covariant IntCell cell) {
    super.swap(cell);
  }

  @override
  IntCell copy() {
    return IntCell(_val);
  }

  @override
  IntCell operator +(IntCell other) {
    return IntCell(_val + other._val);
  }

  @override
  void add(int val) {
    _val = _val + val;
  }

  @override
  IntCell operator -(IntCell other) {
    return IntCell(_val - other._val);
  }

  @override
  void subtract(int val) {
    _val = _val - val;
  }

  @override
  IntCell operator *(IntCell other) {
    return IntCell(_val * other._val);
  }

  @override
  void multiply(int val) {
    _val = _val * val;
  }

  /// Performs integer division of this object.
  IntCell operator ~/(IntCell other) {
    return IntCell(_val ~/ other._val);
  }

  /// Performs integer division of this object.
  void truncDivide(int val) {
    _val = _val ~/ val;
  }

  @override
  IntCell operator %(IntCell other) {
    return IntCell(_val % other._val);
  }

  @override
  void modulo(int val) {
    _val = _val % val;
  }

  @override
  IntCell operator -() {
    return IntCell(-_val);
  }

  @override
  void negate() {
    _val = -_val;
  }

  @override
  void increment() {
    _val = _val + 1;
  }

  @override
  void decrement() {
    _val = _val - 1;
  }

  @override
  bool operator <(IntCell other) {
    return _val < other._val;
  }

  @override
  bool lt(int val) {
    return _val < val;
  }

  @override
  bool operator >(IntCell other) {
    return _val > other._val;
  }

  @override
  bool gt(int val) {
    return _val > val;
  }

  @override
  bool operator <=(IntCell other) {
    return _val <= other._val;
  }

  @override
  bool lte(int val) {
    return _val <= val;
  }

  @override
  bool operator >=(IntCell other) {
    return _val >= other._val;
  }

  @override
  bool gte(int val) {
   return _val >= val;
  }

  @override
  bool eq(int val) {
    return _val == val;
  }

  @override
  bool operator ==(IntCell other) {
    return _val == other._val;
  }

  @override
  int get hashCode => _val.hashCode;
}
