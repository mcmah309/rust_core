part of 'iterator.dart';

/// Zips to iterators into a single iterator of pairs.
final class ZipRIterator<T, U> extends RIterator<(T, U)> {
  final Iterator<T> _iteratorT;
  final Iterator<U> _iteratorU;
  late (T, U) _current;

  ZipRIterator(this._iteratorT, this._iteratorU) : super._late() {
    _wIterator = this;
  }

  @override
  bool moveNext() {
    if (!_iteratorT.moveNext() || !_iteratorU.moveNext()) {
      return false;
    }
    _current = (_iteratorT.current, _iteratorU.current);
    return true;
  }

  @override
  (T, U) get current => _current;
}
