part of 'cell.dart';

extension DoubleConstCellExtensions on ConstCell<double> {
  Cell<double> operator +(ConstCell<double> other) {
    return Cell<double>(_val + other._val);
  }

  Cell<double> operator -(ConstCell<double> other) {
    return Cell<double>(_val - other._val);
  }

  Cell<double> operator *(ConstCell<double> other) {
    return Cell<double>(_val * other._val);
  }

  Cell<double> operator /(ConstCell<double> other) {
    return Cell<double>(_val / other._val);
  }

  Cell<double> operator %(ConstCell<double> other) {
    return Cell<double>(_val % other._val);
  }

  Cell<double> operator -() {
    return Cell<double>(-_val);
  }

  bool operator <(ConstCell<double> other) {
    return _val < other._val;
  }

  /// Less than
  bool lt(double val) {
    return _val < val;
  }

  bool operator >(ConstCell<double> other) {
    return _val > other._val;
  }

  /// Greater than
  bool gt(double val) {
    return _val > val;
  }

  bool operator <=(ConstCell<double> other) {
    return _val <= other._val;
  }

  /// Less than or equal to
  bool lte(double val) {
    return _val <= val;
  }

  bool operator >=(ConstCell<double> other) {
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

extension DoubleCellExtensions on Cell<double> {
  /// Add
  void add(double val) {
    _val = _val + val;
  }

  /// Subtract
  void sub(double val) {
    _val = _val - val;
  }

  /// multiply
  void mul(double val) {
    _val = _val * val;
  }

  /// divide
  void div(double val) {
    _val = _val / val;
  }

  /// modula
  void mod(double val) {
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
