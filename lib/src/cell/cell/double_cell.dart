part of 'cell.dart';

extension DoubleCellExtensions on Cell<double> {
  Cell<double> operator +(Cell<double> other) {
    return Cell<double>(_val + other._val);
  }

  void add(double val) {
    _val = _val + val;
  }

  Cell<double> operator -(Cell<double> other) {
    return Cell<double>(_val - other._val);
  }

  void subtract(double val) {
    _val = _val - val;
  }

  Cell<double> operator *(Cell<double> other) {
    return Cell<double>(_val * other._val);
  }

  void multiply(double val) {
    _val = _val * val;
  }

  Cell<double> operator /(Cell<double> other) {
    return Cell<double>(_val / other._val);
  }

  void divide(double val) {
    _val = _val / val;
  }

  Cell<double> operator %(Cell<double> other) {
    return Cell<double>(_val % other._val);
  }

  void modulo(double val) {
    _val = _val % val;
  }

  Cell<double> operator -() {
    return Cell<double>(-_val);
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

  bool operator <(Cell<double> other) {
    return _val < other._val;
  }

  bool lt(double val) {
    return _val < val;
  }

  bool operator >(Cell<double> other) {
    return _val > other._val;
  }

  bool gt(double val) {
    return _val > val;
  }

  bool operator <=(Cell<double> other) {
    return _val <= other._val;
  }

  bool lte(double val) {
    return _val <= val;
  }

  bool operator >=(Cell<double> other) {
    return _val >= other._val;
  }

  bool gte(double val) {
    return _val >= val;
  }

  bool eq(double val) {
    return _val == val;
  }
}
