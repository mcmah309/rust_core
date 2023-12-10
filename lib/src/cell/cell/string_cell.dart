part of 'cell.dart';

extension StringCellExtensions on Cell<String> {
  Cell<String> operator +(Cell<String> other) {
    return Cell<String>(_val + other._val);
  }

  /// Add
  void add(String val) {
    _val = _val + val;
  }

  /// Equal to
  bool eq(String val) {
    return _val == val;
  }
}