part of 'cell.dart';

extension DoubleCellExtensions on Cell<double> {
  Cell<double> operator +(Cell<double> other) {
    return Cell<double>(_val + other._val);
  }

  /// Add
  void add(double val) {
    _val = _val + val;
  }

  Cell<double> operator -(Cell<double> other) {
    return Cell<double>(_val - other._val);
  }

  /// Subtract
  void sub(double val) {
    _val = _val - val;
  }

  Cell<double> operator *(Cell<double> other) {
    return Cell<double>(_val * other._val);
  }

  /// multiply
  void mul(double val) {
    _val = _val * val;
  }

  Cell<double> operator /(Cell<double> other) {
    return Cell<double>(_val / other._val);
  }

  /// divide
  void div(double val) {
    _val = _val / val;
  }

  Cell<double> operator %(Cell<double> other) {
    return Cell<double>(_val % other._val);
  }

  /// modula
  void mod(double val) {
    _val = _val % val;
  }

  Cell<double> operator -() {
    return Cell<double>(-_val);
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

  bool operator <(Cell<double> other) {
    return _val < other._val;
  }

  /// Less than
  bool lt(double val) {
    return _val < val;
  }

  bool operator >(Cell<double> other) {
    return _val > other._val;
  }

  /// Greater than
  bool gt(double val) {
    return _val > val;
  }

  bool operator <=(Cell<double> other) {
    return _val <= other._val;
  }

  /// Less than or equal to
  bool lte(double val) {
    return _val <= val;
  }

  bool operator >=(Cell<double> other) {
    return _val >= other._val;
  }

  /// Greater than or equal to
  bool gte(double val) {
    return _val >= val;
  }

  /// Equal to
  bool eq(double val) {
    return _val == val;
  }
}
