
part of 'cell.dart';

/// Represents a cell that holds a double value and provides various
/// arithmetic, comparison, and unary operations.
class DoubleCell extends Cell<double> implements _CommonArithmeticOperations<double>, _ComparisonOperations<double>, _UnaryOperations<double> {
  DoubleCell(super.val);

  @override
  void swap(covariant DoubleCell cell) {
    super.swap(cell);
  }

  @override
  DoubleCell copy() {
    return DoubleCell(_val);
  }

  @override
  DoubleCell operator +(DoubleCell other) {
    return DoubleCell(_val + other._val);
  }

  @override
  void add(double val) {
    _val = _val + val;
  }

  @override
  DoubleCell operator -(DoubleCell other) {
    return DoubleCell(_val - other._val);
  }

  @override
  void subtract(double val) {
    _val = _val - val;
  }

  @override
  DoubleCell operator *(DoubleCell other) {
    return DoubleCell(_val * other._val);
  }

  @override
  void multiply(double val) {
    _val = _val * val;
  }

  DoubleCell operator /(DoubleCell other) {
    return DoubleCell(_val / other._val);
  }

  void divide(double val) {
    _val = _val / val;
  }

  @override
  DoubleCell operator %(DoubleCell other) {
    return DoubleCell(_val % other._val);
  }

  @override
  void modulo(double val) {
    _val = _val % val;
  }

  @override
  DoubleCell operator -() {
    return DoubleCell(-_val);
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
  bool operator <(DoubleCell other) {
    return _val < other._val;
  }

  @override
  bool lt(double val) {
    return _val < val;
  }

  @override
  bool operator >(DoubleCell other) {
    return _val > other._val;
  }

  @override
  bool gt(double val) {
    return _val > val;
  }

  @override
  bool operator <=(DoubleCell other) {
    return _val <= other._val;
  }

  @override
  bool lte(double val) {
    return _val <= val;
  }

  @override
  bool operator >=(DoubleCell other) {
    return _val >= other._val;
  }

  @override
  bool gte(double val) {
    return _val >= val;
  }

  @override
  bool eq(double val) {
    return _val == val;
  }

  @override
  bool operator ==(DoubleCell other) {
    return _val == other._val;
  }

  @override
  int get hashCode => _val.hashCode;
}
