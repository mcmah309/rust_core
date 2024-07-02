part of 'iterator.dart';

/// An iterator which can use the "peek" to look at the next element of the iterator without consuming it.
final class Peekable<T> extends RIterator<T> {
  late Iterator<T> _iterator;
  late T _peeked;
  late T _current;
  // Needed since T may be nullable.
  bool _hasPeaked = false;

  Peekable(this._iterator) : super._late() {
    _wIterator = this;
  }

  /// Returns the next element of the iterator without consuming it.
  Option<T> peek() {
    // print("peek");
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
    // print("peek moveNext");
    if (_hasPeaked) {
      _hasPeaked = false;
      _current = _peeked;
      return true;
    }
    if (_iterator.moveNext()) {
      _current = _iterator.current;
      return true;
    }
    return false;
  }

  @override
  T get current => _current;

  @override
  Peekable<T> clone() {
    final temp = Clone._trackable(_iterator);
    _iterator = temp;
    if (_hasPeaked) {
      return Peekable(_PrefixedIterator(_peeked, Clone._clone(temp)));
    }
    return Peekable(Clone._clone(temp));
  }
}

class _PrefixedIterator<T> implements Iterator<T> {
  final T _prefix;
  final Iterator<T> _iterator;
  bool? _isPrefixAlive;

  _PrefixedIterator(this._prefix, this._iterator);

  @override
  T get current {
    //print("prefixed current");
    if (_isPrefixAlive!) {
      return _prefix;
    }
    return _iterator.current;
  }

  @override
  bool moveNext() {
    //print("prefixed moveNext");
    if (_isPrefixAlive == null) {
      _isPrefixAlive = true;
      return true;
    }
    _isPrefixAlive = false;
    return _iterator.moveNext();
  }
}
