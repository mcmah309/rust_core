import 'package:rust_core/slice.dart';
import 'package:rust_core/option.dart';

extension type RIterator<T>(Iterable<T> iterable) implements Iterable<T> {
  RIterator.fromSlice(Slice<T> slice) : iterable = slice;

// advance_by
// all
// any
// array_chunks
// by_ref
// chain
// cloned
// cmp
// cmp_by
// collect
// collect_into
// copied
// count
// cycle
// enumerate
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
      if (result is Some<U>) {
        yield result.v;
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
      if (result is Some<U>) {
        return result;
      }
    }
    return None();
  }
// flat_map
// flatten
// fold: Implemented by Iterable.fold
// for_each
// fuse
// ge
// gt
// inspect
// intersperse
// intersperse_with
// is_partitioned
// is_sorted
// is_sorted_by
// is_sorted_by_key
// last
// le
// lt

  RIterator<K> map<K>(K Function(T) f) {
    return RIterator<K>(iterable.map((e) => f(e)));
  }

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
// reduce
// rev
// rposition
// scan
// size_hint
// skip
// skip_while
// step_by
// sum
// take
// take_while
// try_collect
// try_find
// try_fold
// try_for_each
// try_reduce
// unzip
// zip
}
