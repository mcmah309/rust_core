class FollowedByIterator<E> implements Iterator<E> {
  Iterator<E> _currentIterator;
  Iterable<E>? _nextIterable;

  FollowedByIterator(Iterable<E> first, this._nextIterable)
      : _currentIterator = first.iterator;

  bool moveNext() {
    if (_currentIterator.moveNext()) return true;
    if (_nextIterable != null) {
      _currentIterator = _nextIterable!.iterator;
      _nextIterable = null;
      return _currentIterator.moveNext();
    }
    return false;
  }

  E get current => _currentIterator.current;
}