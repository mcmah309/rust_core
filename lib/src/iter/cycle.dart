part of 'iterator.dart';

/// Creates an iterator which repeats the elements of the original iterator endlessly.
final class Cycle<T> extends RIterator<T> {
  final List<T> _cycled = [];
  final Iterator<T> _iterator;
  int index = -1;

  Cycle(this._iterator): super.late(){
    _wIterator = this;
  }

  @override
  bool moveNext() {
    index++;
    if (_iterator.moveNext()){
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
}