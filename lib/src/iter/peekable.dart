

import 'package:rust_core/option.dart';

/// An iterator which can use the "peek" to look at the next element of the iterator without consuming it.
class PeekableIterator<T> implements Iterator<T> {
  final Iterator<T> _iterator;
  Option<T> _peeked = None;

  PeekableIterator(this._iterator);

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

/// An iterable which can use the "peek" to look at the next element of the iterator without consuming it.
class Peekable<T> extends Iterable<T> {
  final Iterable<T> _iterable;

  Peekable(this._iterable);

  @override
  PeekableIterator<T> get iterator {
    return PeekableIterator(_iterable.iterator);
  }
}