/// Zips to iterators into a single iterator of pairs.
class Zip<T,U> extends Iterable<(T,U)> {
  final Iterable<T> _iterableT;
  final Iterable<U> _iterableU;

  Zip(this._iterableT, this._iterableU);

  @override
  IteratorZip<T,U> get iterator {
    return IteratorZip<T,U>(_iterableT.iterator,_iterableU.iterator);
  }
}

class IteratorZip<T,U> implements Iterator<(T,U)> {
  final Iterator<T> _iteratorT;
  final Iterator<U> _iteratorU;
  late (T,U) _current;

  IteratorZip(this._iteratorT,this._iteratorU);

  @override
  bool moveNext() {
    if (!_iteratorT.moveNext() || !_iteratorU.moveNext()) {
      return false;
    }
    _current = (_iteratorT.current,_iteratorU.current);
    return true;
  }

  @override
  (T,U) get current => _current;
}