part of 'iterator.dart';


class FlatMap<S, T> extends _BaseRIterator<T> {
  final Iterator<S> _iterator;
  final Iterator<T> Function(S) _f;
  late Iterator<T> _currentExpansion;

  FlatMap(this._iterator, this._f): super.late(){
    wIterator = this;
  }

  @override
  T get current => _currentExpansion.current;

  @override
  bool moveNext() {
    while (_currentExpansion.moveNext()) {
      return true;
    }
    if (_iterator.moveNext()) {
      _currentExpansion = _f(_iterator.current);
      return moveNext();
    }
    return false;
  }
}