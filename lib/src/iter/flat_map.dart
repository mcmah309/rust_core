part of 'iterator.dart';

/// Maps each element of the original iterator to an iterator, and then flattens the result into a single iterator.
final class FlatMapRIterator<S, T> extends RIterator<T> {
  Iterator<S> _iterator;
  final Iterator<T> Function(S) _f;
  Iterator<T>? _currentExpansion;

  FlatMapRIterator(this._iterator, this._f) : super._late() {
    _wIterator = this;
  }

  @override
  T get current => _currentExpansion!.current;

  @override
  bool moveNext() {
    if (_currentExpansion != null && _currentExpansion!.moveNext()) {
      return true;
    }
    if (_iterator.moveNext()) {
      _currentExpansion = _f(_iterator.current);
      if(_currentExpansion!.moveNext()) {
        return true;
      }
      return false;
    }
    return false;
  }
  
  @override
  FlatMapRIterator<S,T> clone() {
    final temp = CloneRIterator._trackable(_iterator);
    _iterator = temp;
    if (_currentExpansion != null) {
      final newCurrentExpansion = CloneRIterator._trackable(_currentExpansion!);
      _currentExpansion = newCurrentExpansion;
      return FlatMapRIterator(CloneRIterator._clone(temp).iterator, _f).._currentExpansion = CloneRIterator._clone(newCurrentExpansion);
    }
    return FlatMapRIterator(CloneRIterator._clone(temp), _f);
  }
}
