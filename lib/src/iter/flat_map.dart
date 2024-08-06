part of 'iterator.dart';

/// Maps each element of the original iterator to an iterator, and then flattens the result into a single iterator.
final class FlatMap<S, T> extends Iter<T> {
  Iterator<S> _iterator;
  final Iterator<T> Function(S) _f;
  Iterator<T>? _currentExpansion;

  FlatMap(this._iterator, this._f) : super._late() {
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
      if (_currentExpansion!.moveNext()) {
        return true;
      }
      return false;
    }
    return false;
  }

  @override
  FlatMap<S, T> clone() {
    final temp = Clone._trackable(_iterator);
    _iterator = temp;
    if (_currentExpansion != null) {
      final newCurrentExpansion = Clone._trackable(_currentExpansion!);
      _currentExpansion = newCurrentExpansion;
      return FlatMap(Clone._clone(temp).iterator, _f)
        .._currentExpansion = Clone._clone(newCurrentExpansion);
    }
    return FlatMap(Clone._clone(temp), _f);
  }
}
