part of 'cell.dart';

class BoolCell extends Cell<bool> {
  BoolCell(super.val);

  @override
  void swap(covariant BoolCell cell) {
    super.swap(cell);
  }

  @override
  BoolCell copy() {
    return BoolCell(_val);
  }

  @override
  bool operator ==(BoolCell other) {
    return _val == other._val;
  }

  @override
  int get hashCode => _val.hashCode;
}