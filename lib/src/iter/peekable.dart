part of 'iterator.dart';

/// An iterator which can use the "peek" to look at the next element of the iterator without consuming it.
final class PeekableRIterator<T> extends RIterator<T> {
  final Iterator<T> _iterator;
  late T _peeked;
  // Needed since T may be nullable.
  bool _hasPeaked = false;

  PeekableRIterator(this._iterator) : super._late() {
    _wIterator = this;
  }

  /// Returns the next element of the iterator without consuming it.
  Option<T> peek() {
    if (_hasPeaked) {
      return Some(_peeked);
    }
    if (_iterator.moveNext()) {
      _peeked = _iterator.current;
      _hasPeaked = true;
      return Some(_peeked);
    }
    return None;
  }

  @override
  bool moveNext() {
    if (_hasPeaked) {
      _hasPeaked = false;
      return true;
    }
    return _iterator.moveNext();
  }

  @override
  T get current => _hasPeaked ? _peeked : _iterator.current;
}
