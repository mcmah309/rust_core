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
  bool le(Iterator<U> other) {
    return cmp(other) <= 0;
  }

  /// Determines if the elements of this Iterator are lexicographically less than those of another.
  bool lt(Iterator<U> other) {
    return cmp(other) < 0;
  }

  /// Determines if the elements of this Iterator are not equal to those of another.
  bool ne(Iterator<U> other) {
    return cmp(other) != 0;
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

  /// Returns the maximum element of an iterator.
  Option<T> max() {
    if (!moveNext()) {
      return None;
    }
    var max = current;
    while (moveNext()) {
      if (current.compareTo(max) > 0) {
        max = current;
      }
    }
    return Some(max);
  }

  /// Returns the minimum element of an iterator.
  Option<T> min() {
    if (!moveNext()) {
      return None;
    }
    var min = current;
    while (moveNext()) {
      if (current.compareTo(min) < 0) {
        min = current;
      }
    }
    return Some(min);
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
  /// Transforms an iterator into a collection, short circuiting if a Err is encountered.
  Result<List<T>, E> tryCollect() {
    final result = <T>[];
    for (final res in this) {
      if (res.isErr()) {
        return res.intoUnchecked();
      }
      result.add(res.unwrap());
    }
    return Ok(result);
  }

  /// Applies function to the elements of iterator and returns the first true result or the first Err element.
  Result<Option<T>, E> tryFind(bool Function(T) f) {
    for (final res in this) {
      if (res.isErr()) {
        return res.intoUnchecked();
      }
      if (f(res.unwrap())) {
        return Ok(Some(res.unwrap()));
      }
    }
    return Ok(None);
  }

  /// An iterator method that applies a function producing a single value, returns Err is encounted.
  Result<U, E> tryFold<U>(U initial, U Function(U, T) f) {
    var accum = initial;
    for (final res in this) {
      if (res.isErr()) {
        return res.intoUnchecked();
      }
      accum = f(accum, res.unwrap());
    }
    return Ok(accum);
  }

  /// An iterator method that applies a function, stopping at the first Err and returning that Err.
  Result<(), E> tryForEach(void Function(T) f) {
    for (final res in this) {
      if (res.isErr()) {
        return res.intoUnchecked();
      }
      f(res.unwrap());
    }
    return const Ok(());
  }

  /// Reduces the elements to a single one by repeatedly applying a reducing operation. If a Err is encounted it is returned.
  Result<Option<T>, E> tryReduce(T Function(T, T) f) {
    if (!moveNext()) {
      return Ok(None);
    }
    var accumRes = current;
    if (accumRes.isErr()) {
      return accumRes.intoUnchecked();
    }
    var accum = accumRes.unwrap();
    while (moveNext()) {
      if (current.isErr()) {
        return current.intoUnchecked();
      }
      accum = f(accum, current.unwrap());
    }
    return Ok(Some(accum));
  }
}

extension IteratorResultFuncExtension<T> on RIterator<T> {
  /// Applies function to the elements of iterator and returns the first true result or the first error.
  Result<Option<T>, E> tryFind<E extends Object>(Result<bool, E> Function(T) f) {
    for (final res in this) {
      final found = f(res);
      if (found.isErr()) {
        return found.intoUnchecked();
      }
      if (found.unwrap()) {
        return Ok(Some(res));
      }
    }
    return Ok(None);
  }

  /// An iterator method that applies a function as long as it returns successfully, producing a single, final value.
  Result<U, E> tryFold<U, E extends Object>(U initial, Result<U, E> Function(U, T) f) {
    var accum = initial;
    for (final res in this) {
      final folded = f(accum, res);
      if (folded.isErr()) {
        return folded.intoUnchecked();
      }
      accum = folded.unwrap();
    }
    return Ok(accum);
  }

  /// An iterator method that applies a fallible function to each item in the iterator, stopping at the first error and returning that error.
  Result<(), E> tryForEach<E extends Object>(Result<(), E> Function(T) f) {
    for (final res in this) {
      final result = f(res);
      if (result.isErr()) {
        return result.intoUnchecked();
      }
    }
    return const Ok(());
  }

  /// Reduces the elements to a single one by repeatedly applying a reducing operation. If the closure returns a failure, the failure is propagated back to the caller immediately.
  Result<Option<T>, E> tryReduce<E extends Object>(Result<T, E> Function(T, T) f) {
    if (!moveNext()) {
      return Ok(None);
    }
    var accum = current;
    while (moveNext()) {
      final next = current;
      final res = f(accum, next);
      if (res.isErr()) {
        return res.intoUnchecked();
      }
      accum = res.unwrap();
    }
    return Ok(Some(accum));
  }
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
