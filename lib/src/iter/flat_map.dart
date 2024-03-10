part of 'iterator.dart';

/// Maps each element of the original iterator to an iterator, and then flattens the result into a single iterator.
final class FlatMap<S, T> extends RIterator<T> {
  final Iterator<S> _iterator;
  final Iterator<T> Function(S) _f;
  Iterator<T>? _currentExpansion;

  FlatMap(this._iterator, this._f): super._late(){
    _wIterator = this;
  }

  @override
  T get current => _currentExpansion!.current;

  @override
  bool moveNext() {
    while (_currentExpansion != null && _currentExpansion!.moveNext()) {
      return true;
    }
    if (_iterator.moveNext()) {
      _currentExpansion = _f(_iterator.current);
      return moveNext();
    }
    return false;
  }
}