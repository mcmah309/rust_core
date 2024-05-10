part of 'iterator.dart';

/// Takes two iterators and creates a new iterator over both in sequence.
final class ChainRIterator<T> extends RIterator<T> {
  Iterator<T> _first;
  Iterator<T> _second;
  bool isFirst = true;

  ChainRIterator(this._first, this._second) : super._late() {
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

  @override
  ChainRIterator<T> clone() {
    final newFirst = CloneRIterator._trackable(_first);
    final newSecond = CloneRIterator._trackable(_second);
    _first = newFirst;
    _second = newSecond;
    return ChainRIterator(
        CloneRIterator._clone(newFirst), CloneRIterator._clone(newSecond))
      ..isFirst = isFirst;
  }
}
