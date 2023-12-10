part of 'cell.dart';

extension BoolCellExtensions on Cell<bool> {

  /// "!" on the inner bool value. e.g. val = !val;
  void not() {
    _val = !_val;
  }

  /// Equal to
  bool eq(bool val) {
    return _val == val;
  }
}