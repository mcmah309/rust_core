part of 'iterator.dart';

/// An iterator which is a "clone" of the original iterator. Iterating through the original or the clone will not affect the other.
/// Note: Do not modify the original collection the original [Iterable] is based on while iterating.
/// Explanation:
/// Since Dart [Iterator]s cannot be copied,
/// [Clone] replaces the underlying iterator from the [RIterator] provided in the constructor with itself and
/// collects any first calls to [moveNext] from any derived iterator.
/// Due to this, modifications of the original iterable may have
/// unintentional behavior on the cloned iterator. i.e. the first encounter of an object during iteration will be the one
/// seen by the derived [RIterator] and all other subsequent [Clone]s.
/// Therefore if createing a [Clone] do not modify the original
/// collection the passed in [RIterator] is based on.
final class Clone<T> extends RIterator<T> {
  final List<T> _trackedValues;
  late final _CollectingIterator<T> _iterator;
  int index = -1;

  Clone._original(RIterator<T> rIterator)
      : _trackedValues = [],
        super._late() {
    _wIterator = this;
    _iterator = _CollectingIterator(rIterator._wIterator, _trackedValues);
    rIterator._wIterator = _iterator;
  }

  /// Clone of the iterator. Creates a seperate [Clone] which will not affect the original.
  Clone._clone(Clone<T> iterator)
      : _iterator = iterator._iterator,
        _trackedValues = iterator._trackedValues,
        index = iterator.index,
        super._late() {
    _wIterator = this;
  }

  /// To be used by subclasses to wrap their own iterators.
  Clone._trackable(Iterator<T> iterator)
      : _trackedValues = [],
        super._late() {
    _wIterator = this;
    _iterator = _CollectingIterator(iterator, _trackedValues);
  }

  @override
  bool moveNext() {
    // print("clone moveNext");
    if (_iterator.existsAtIndex(index + 1)) {
      index++;
      return true;
    }
    return false;
  }

  @override
  T get current {
    // print("clone current");
    return _trackedValues[index];
  }

  @override
  Clone<T> clone() {
    return Clone._clone(this);
  }
}

class _CollectingIterator<T> implements Iterator<T> {
  final Iterator<T> _iterator;
  final List<T> _trackedValues;
  int index = -1;

  _CollectingIterator(this._iterator, this._trackedValues);

  @override
  T get current {
    //print("collecting current");
    return _trackedValues[index];
  }

  @override
  bool moveNext() {
    //print("collecting moveNext");
    if (_trackedValues.length > index + 1) {
      index++;
      return true;
    }
    if (_iterator.moveNext()) {
      _trackedValues.add(_iterator.current);
      index++;
      return true;
    }
    return false;
  }

  bool existsAtIndex(int index) {
    //print("collecting existsAtIndex");
    while (_trackedValues.length <= index) {
      if (_iterator.moveNext()) {
        _trackedValues.add(_iterator.current);
      } else {
        return false;
      }
    }
    return true;
  }
}
