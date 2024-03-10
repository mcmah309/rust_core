part of 'iterator.dart';

extension IterableExtension<T> on Iterable<T> {
  /// Returns an [RIterator] over the [Iterable].
  RIterator<T> iter() => RIterator<T>(iterator);
}

extension IteratorExtension<T> on Iterator<T> {
  /// Returns an [RIterator] for this [Iterator].
  RIterator<T> iter() => RIterator<T>(this);
}

extension IteratorOnIteratorIterabel<T> on RIterator<Iterable<T>> {
  /// Flatten an iterator of iterators into a single iterator.
  RIterator<T> flatten() {
    return RIterator(_flattenHelper().iterator);
  }

  Iterable<T> _flattenHelper() sync* {
    for (final iterator in this) {
      for (final value in iterator) {
        yield value;
      }
    }
  }
}

extension IteratorSliceExtension<T> on RIterator<Slice<T>> {
  //todo
}

extension IteratorIterableExtension<T> on RIterator<Iterable<T>> {
  //todo
}


extension IteratorComparable<U,T extends Comparable<U>> on RIterator<T> {
    /// Lexicographically compares the elements of this Iterator with those of another.
    /// Less = -1
    /// Equal = 0
    /// Greater = 1
    int cmp(Iterable<U> other) {
      final otherIterator = other.iterator;
      final thisIterator = iterator;
      while (true) {
        if (thisIterator.moveNext()) {
          if (otherIterator.moveNext()) {
            final cmp = thisIterator.current.compareTo(otherIterator.current);
            if (cmp != 0) {
              return cmp;
            }
          } else {
            return 1;
          }
        } else {
          if (otherIterator.moveNext()) {
            return -1;
          } else {
            return 0;
          }
        }
      }
    }

    /// Determines if the elements of this Iterator are lexicographically greater than or equal to those of another.
    bool ge(Iterable<U> other) {
      return cmp(other) >= 0;
    }

    /// Determines if the elements of this Iterator are lexicographically greater than those of another.
    bool gt(Iterable<U> other) {
      return cmp(other) > 0;
    }

  

}

extension IteratorOptionExtension<T> on RIterator<Option<T>> {
  /// Creates an iterator which ends after the first None.
  RIterator<T> fuse() {
    return RIterator(_fuseHelper().iterator);
  }

  Iterable<T> _fuseHelper() sync* {
    for (final option in this) {
      if (option.isNone()) {
        break;
      }
      yield option.unwrap();
    }
  }
}

extension IteratorResultExtension<T, E extends Object> on RIterator<Result<T, E>> {
  //todo
}

extension IteratorOnIteratorTUExtension<T, U> on RIterator<(T, U)> {
  /// Converts an iterator of pairs into a pair of containers.
  (List<T>, List<U>) unzip() {
    final first = <T>[];
    final second = <U>[];
    for (final (t, u) in this) {
      first.add(t);
      second.add(u);
    }
    return (first, second);
  }
}
