
part 'int_cell.dart';

class Cell<T> {
  T _val;

  Cell(T val): _val = val;

  T get() {
    return _val;
  }

  T replace(T val){
    final temp = _val;
    _val = val;
    return temp;
  }

  void set(T val){
    _val = val;
  }

  void swap(Cell<T> cell){
    final temp = cell._val;
    cell._val = _val;
    _val = temp;
  }

  T update(T Function(T) fn){
    _val = fn(_val);
    return _val;
  }

  Cell<T> copy(){
    return Cell(_val);
  }

  @override
  int get hashCode => _val.hashCode;

  @override
  bool operator ==(Object other) {
    return other is Cell && other._val == _val;
  }

  @override
  String toString() {
    return "$runtimeType($_val)";
  }
}


