part of 'iterator.dart';

/// An iterator which can use the "peek" to look at the next element of the iterator without consuming it.
final class Peekable<T> extends RIterator<T> {
  final Iterator<T> _iterator;
  Option<T> _peeked = None;

  Peekable(this._iterator) : super._late() {
    _wIterator = this;
  }

  /// Returns the next element of the iterator without consuming it.
  Option<T> peek() {
    if (_peeked.isNone()) {
      if (_iterator.moveNext()) {
        _peeked = Some(_iterator.current);
      }
    }
    return _peeked;
  }

  @override
  bool moveNext() {
    if (_peeked.isSome()) {
      _peeked = None;
      return true;
    }
    return _iterator.moveNext();
  }

  @override
  T get current => _peeked.unwrapOr(_iterator.current);
}
