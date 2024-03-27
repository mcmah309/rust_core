part of 'iterator.dart';

/// Creates an iterator which repeats the elements of the original iterator endlessly.
final class CycleRIterator<T> extends RIterator<T> {
  final List<T> _cycled = [];
  Iterator<T> _iterator;
  int index = -1;

  CycleRIterator(this._iterator) : super._late() {
    _wIterator = this;
  }

  @override
  bool moveNext() {
    index++;
    if (_iterator.moveNext()) {
      _cycled.add(_iterator.current);
      return true;
    }
    if (_cycled.isEmpty) {
      return false;
    }
    return true;
  }

  @override
  T get current => _cycled[index % _cycled.length];

  @override
  CycleRIterator<T> clone() {
    final temp = CloneRIterator._trackable(_iterator);
    _iterator = temp;
    return CycleRIterator(CloneRIterator._clone(temp).iterator)
      .._cycled.addAll(_cycled)
      ..index = index;
  }
}
