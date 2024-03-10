// ignore_for_file: library_private_types_in_public_api

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

extension IteratorComparable<U, T extends Comparable<U>> on RIterator<T> {
  /// Lexicographically compares the elements of this Iterator with those of another.
  /// Less = -1
  /// Equal = 0
  /// Greater = 1
  int cmp(Iterator<U> other) {
    while (true) {
      if (moveNext()) {
        if (other.moveNext()) {
          final cmp = current.compareTo(other.current);
          if (cmp != 0) {
            return cmp;
          }
        } else {
          return 1;
        }
      } else {
        if (other.moveNext()) {
          return -1;
        } else {
          return 0;
        }
      }
    }
  }

  /// Determines if the elements of this Iterator are lexicographically greater than or equal to those of another.
  bool ge(Iterator<U> other) {
    return cmp(other) >= 0;
  }

  /// Determines if the elements of this Iterator are lexicographically greater than those of another.
  bool gt(Iterator<U> other) {
    return cmp(other) > 0;
  }

  /// Determines if the elements of this Iterator are lexicographically less or equal to those of another.
  bool le(Iterator<U> other){
    return cmp(other) <= 0;
  }
  
  /// Determines if the elements of this Iterator are lexicographically less than those of another.
  bool lt(Iterator<U> other){
    return cmp(other) < 0;

  }
}

extension IteratorComparableSelf<T extends Comparable<T>> on RIterator<T> {
  /// Checks if the elements of this iterator are sorted.
  /// That is, for each element a and its following element b, a <= b must hold. If the iterator yields exactly zero or one element, true is returned.
  bool isSorted() {
    while (moveNext()) {
      var prevVal = current;
      if (moveNext()) {
        if (prevVal.compareTo(current) > 0) {
          return false;
        }
      }
    }
    return true;
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

//************************************************************************//

/// Overrides built in extension methods on nullable [Iterable].
extension NullableIterableExtensionsOverrides<T extends Object> on RIterator<T?> {
  /// Returns an RIterator over the non-null elements of this iterator.
  RIterator<T> nonNulls() => RIterator.fromIterable(NullableIterableExtensions(this).nonNulls);
}

/// Overrides built in extension methods on [Iterable].
extension IterableExtensionsOverrides<T> on RIterator<T> {
  /// Returns an RIterator over the elements of this iterable, paired with their index.
  RIterator<(int, T)> get indexed => RIterator.fromIterable(IterableExtensions(this).indexed);

  @Deprecated(
      "FirstOrNull is not supported as it would require consuming part of the iterator, which is likely not the users intent. Use next() instead.")
  Never firstOrNull() =>
      throw "FirstOrNull is not supported as it would require consuming part of the iterator, which is likely not the users intent. Use next() instead.";

  /// Returns the last element of this iterable, or `null` if the iterable is empty.
  T? lastOrNull() => IterableExtensions(this).lastOrNull;

  @Deprecated(
      "SingleOrNull is not supported as it would require consuming part of the iterator, which is likely not the users intent. Use next() instead.")
  Never singleOrNull() =>
      throw "SingleOrNull is not supported as it would require consuming part of the iterator, which is likely not the users intent. Use peekable() instead.";

  @Deprecated(
      "ElementAtOrNull is not supported as it would require consuming part of the iterator, which is likely not the users intent. Use nth() instead.")
  Never elementAtOrNull(int index) =>
      throw "ElementAtOrNull is not supported as it would require consuming part of the iterator, which is likely not the users intent. Use nth() instead.";
}
