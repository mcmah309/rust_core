part of 'iterator.dart';

extension IteratorExtension<T extends Object> on Iterator<T> {
  /// If the iterator is empty, returns None. Otherwise, returns the next value wrapped in Some.
  Option<T> next() {
    if (moveNext()) {
      return Some(current);
    }
    return None;
  }
}

extension IterableExtension<T> on Iterable<T> {
  /// Returns an [RIterator] over the [Iterable].
  RIterator<T> iter() => RIterator<T>(this);
}

extension IteratorOnIteratorIterabel<T> on RIterator<Iterable<T>> {
  /// Flatten an iterator of iterators into a single iterator.
  RIterator<T> flatten() {
    return RIterator(_flattenHelper());
  }

  Iterable<T> _flattenHelper() sync* {
    for (final iterator in iterable) {
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

extension IteratorOptionExtension<T> on RIterator<Option<T>> {
  /// Creates an iterator which ends after the first None.
  RIterator<T> fuse() {
    return RIterator(_fuseHelper());
  }

  Iterable<T> _fuseHelper() sync* {
    for (final option in iterable) {
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
    for (final (t, u) in iterable) {
      first.add(t);
      second.add(u);
    }
    return (first, second);
  }
}
