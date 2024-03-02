import 'package:rust_core/result.dart';
import 'package:rust_core/slice.dart';
import 'package:rust_core/option.dart';

part 'iterator_extensions.dart';

extension type RIterator<T>(Iterable<T> iterable) implements Iterable<T> {
  RIterator.fromSlice(Slice<T> slice) : iterable = slice;

// advance_by: //todo

  bool all(bool Function(T) f) => iterable.every(f);

// any: Implemented by Iterable.any
// array_chunks
// by_ref
// chain
// cloned
// cmp
// cmp_by
// collect: Will also be implemented by extensions

  List<T> collectList({bool growable = true}) {
    return iterable.toList(growable: growable);
  }

  Set<T> collectSet() {
    return iterable.toSet();
  }

// collect_into: Will not be implemented, no dart equivalent
// contains: Implemented by Iterable.contains
// copied: Will not be implemented, no dart equivalent

  /// Counting the number of iterations and returning it.
  int count() => iterable.length;

// cycle: //todo

  /// Creates an iterator which gives the current iteration count as well as the next value.
  RIterator<(int, T)> enumerate() => RIterator(iterable.indexed);

// eq
// eq_by

  /// Creates an iterator which uses a closure to determine if an element should be yielded.
  RIterator<T> filter(bool Function(T) f) {
    return RIterator<T>(iterable.where((element) => f(element)));
  }

  /// Creates an iterator that both filters and maps.
  /// The returned iterator yields only the values for which the supplied closure returns Some(value).
  RIterator<U> filterMap<U>(Option<U> Function(T) f) {
    return RIterator(_filterMapHelper(f));
  }

  Iterable<U> _filterMapHelper<U>(Option<U> Function(T) f) sync* {
    for (final element in iterable) {
      final result = f(element);
      if (result.isSome()) {
        yield result.v!;
      }
    }
  }

  /// Searches for an element of an iterator that satisfies a predicate.
  Option<T> find(bool Function(T) f) {
    for (final element in iterable) {
      if (f(element)) {
        return Some(element);
      }
    }
    return None();
  }

  /// Applies the function to the elements of iterator and returns the first non-none result.
  Option<U> findMap<U>(Option<U> Function(T) f) {
    for (final element in iterable) {
      final result = f(element);
      if (result.isSome()) {
        return result;
      }
    }
    return None();
  }

  /// Creates an iterator that works like map, but flattens nested structure.
  RIterator<U> flatMap<U>(Iterable<U> Function(T) f) {
    return RIterator(iterable.expand(f));
  }

// flatten: //todo, in extension
// fold: Implemented by Iterable.fold
// for_each: Implemented by Iterable.forEach
// fuse
// ge
// gt

  /// Does something with each element of an iterator, passing the value on.
  RIterator<T> inspect(void Function(T) f) {
    return RIterator(_inspectHelper(f));
  }

  Iterable<T> _inspectHelper(void Function(T) f) sync* {
    for (final element in iterable) {
      f(element);
      yield element;
    }
  }

// intersperse
// intersperse_with
// is_partitioned
// is_sorted
// is_sorted_by
// is_sorted_by_key
// last: Implemented by Iterable.last

  /// Returns the last element of an iterator, or None if it is empty.
  Option<T> lastOrOption() {
    if (iterable.isEmpty) {
      return None();
    }
    return Some(iterable.last);
  }

// le
// lt
// map: Implemented by Iterable.map
// map_while
// map_windows
// max
// max_by
// max_by_key
// min
// min_by
// min_by_key
// ne
// next_chunk
// nth
// partial_cmp
// partial_cmp_by
// partition
// partition_in_place
// peekable
// position
// product
// reduce: Implemented by Iterable.reduce
// rev
// rposition
// scan
// size_hint
// skip: Implemented by Iterable.skip
// skip_while: Implemented by Iterable.skipWhile
// step_by
// sum
// take: Implemented by Iterable.take
// take_while: Implemented by Iterable.takeWhile
// try_collect
// try_find
// try_fold
// try_for_each
// try_reduce
// unzip
// zip
}
