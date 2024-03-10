part of 'iterator.dart';

/// Zips to iterators into a single iterator of pairs.
class Zip<T,U> extends _BaseRIterator<(T,U)> {
  final Iterator<T> _iteratorT;
  final Iterator<U> _iteratorU;
  late (T,U) _current;

  Zip(this._iteratorT,this._iteratorU): super.late(){
    wIterator = this;
  }

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