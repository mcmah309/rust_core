part of 'iterator.dart';

/// An iterator which is a "clone" of the original iterator. Iterating through the original or the clone will not affect the other.
/// Note: Do not modify the original collection the original [Iterable] is based on while iterating.
/// Explanation:
/// Since Dart [Iterator]s cannot be copied,
/// [CloneRIterator] replaces the underlying iterator from the [RIterator] provided in the constructor with itself and 
/// collects any first calls to [moveNext] from any derived iterator.
/// Due to this, modifications of the original iterable may have 
/// unintentional behavior on the cloned iterator. i.e. the first encounter of an object during iteration will be the one
/// seen by the derived [RIterator] and all other subsequent [CloneRIterator]s.
/// Therefore if createing a [CloneRIterator] do not modify the original
/// collection the passed in [RIterator] is based on.
final class CloneRIterator<T> extends RIterator<T> {
  /// Shared amoung all [CloneRIterator]s that where derived from the same [RIterator].
  final List<T> _cloned;
  final Iterator<T> _iterator;
  int start = 0;
  int index = -1;

  /// This should only be called by an [RIterator] whose [_wIterator] is not a [CloneRIterator].
  CloneRIterator._original(RIterator<T> rIterator) : _iterator = rIterator._wIterator, _cloned = [], assert(rIterator is! CloneRIterator<T>), super._late() {
    _wIterator = this;
    rIterator._wIterator = CloneRIterator._clone(this);
  }

  // /// Wraps the original iterator so that any iteration is tracked in the cloned list.
  // CloneRIterator._wrapped(this._iterator, this._cloned): super._late() {
  //   _wIterator = this;
  // }

  CloneRIterator._clone(CloneRIterator<T> iterator) : _iterator = iterator._iterator, _cloned = iterator._cloned, start = iterator.index + 1, index = iterator.index, super._late() {
    _wIterator = this;
  }

  @override
  bool moveNext() {
    if(index == _cloned.length - 1) {
      if(_iterator.moveNext()) {
        _cloned.add(_iterator.current);
        index++;
        return true;
      } else {
        return false;
      }
    }
    index++;
    return true;
  }

  @override
  T get current => _cloned[index];
}