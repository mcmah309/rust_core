import 'package:rust_core/slice.dart';


extension type RIterator<T>(Iterable<T> iterable) implements Iterable<T> {

  RIterator.fromSlice(Slice<T> slice): iterable = slice;

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

  RIterator<T> filter(bool Function(T) f) {
    return RIterator<T>(iterable.where((element) => f(element)));
  }

// filter_map
// find
// find_map
// flat_map
// flatten
// fold
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