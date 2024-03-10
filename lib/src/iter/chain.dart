part of 'iterator.dart';

/// Takes two iterators and creates a new iterator over both in sequence.
final class Chain<T> extends RIterator<T> {
  final Iterator<T> _first;
  final Iterator<T> _second;
  bool isFirst = true;

  Chain(this._first, this._second) : super._late() {
    _wIterator = this;
  }

  @override
  bool moveNext() {
    if (isFirst) {
      if (_first.moveNext()) {
        return true;
      } else {
        isFirst = false;
      }
    }
    return _second.moveNext();
  }

  @override
  T get current => isFirst ? _first.current : _second.current;
}
