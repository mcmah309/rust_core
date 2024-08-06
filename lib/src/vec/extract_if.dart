import 'vec.dart';

/// Creates an iterator which uses a closure to determine if an element should be removed.
/// If the closure returns true, then the element is removed and yielded. If the closure returns false,
/// the element will remain in the vector and will not be yielded by the iterator.
class ExtractIfIterator<T> implements Iterator<T> {
  final Vec<T> _vec;
  int _index = 0;
  final bool Function(T) _test;
  late T _current;

  ExtractIfIterator(this._vec, this._test);

  @override
  bool moveNext() {
    while (_index < _vec.len()) {
      final current = _vec[_index];
      if (_test(current)) {
        _current = current;
        _vec.removeAt(_index);
        return true;
      } else {
        _index++;
      }
    }
    return false;
  }

  @override
  T get current => _current;
}

class ExtractIfIterable<T> extends Iterable<T> {
  final Vec<T> vec;
  final bool Function(T) _test;

  ExtractIfIterable(this.vec, this._test);

  @override
  Iterator<T> get iterator => ExtractIfIterator(vec, _test);
}
