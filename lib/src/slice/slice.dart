import 'package:rust_core/option.dart';

part '../iter/iterator.dart';

/// A contiguous sequence of elements in a [Iterable]. Slices are a view into a list without allocating a new list, and do not own their own data.
/// Be careful with slices, as modifying the size of the original list can cause the slices range to change,
/// but the slice will not throw an exception
// ignore: library_private_types_in_public_api
// extension type const Slice<T>._(_Slice<T> _slice) {
//   Slice(List<T> list, int start, int end) : _slice = _Slice(start: start, end: end, list: list), assert(start >= 0 && end <= list.length, "Index out of bounds");

//   Slice.fromList(List<T> list) : _slice = (start: 0, end: list.length, list: list);

// // align_to: Will not implmented, not possible in Dart
// // align_to_mut: Will not implmented, not possible in Dart
// // array_chunks: //todo
// // array_chunks_mut: Will not implmented, covered by array_chunks
// // array_windows: //todo
// // as_ascii: Will not implmented, not possible in Dart
// // as_ascii_unchecked: Will not implmented, not possible in Dart
// // as_bytes: Will not implmented, not possible in Dart
// // as_chunks: //todo
// // as_chunks_mut: Will not implmented, covered by as_chunks
// // as_chunks_unchecked: //todo
// // as_chunks_unchecked_mut: Will not implmented, covered by as_chunks_unchecked
// // as_mut_ptr: Will not implmented, not possible in Dart
// // as_mut_ptr_range: Will not implmented, not possible in Dart
// // as_ptr: Will not implmented, not possible in Dart
// // as_ptr_range: Will not implmented, not possible in Dart
// // as_rchunks: //todo
// // as_rchunks_mut: Will not implmented, covered by as_rchunks
// // as_simd: //todo
// // as_simd_mut: Will not implmented, covered by as_simd
// // as_str: Will not implmented, not possible in Dart
// // binary_search: //todo
// // binary_search_by: //todo
// // binary_search_by_key: //todo
// // chunks: //todo
// // chunks_exact: //todo
// // chunks_exact_mut: Will not implmented, covered by chunks_exact
// // chunks_mut: Will not implmented, covered by chunks
// // clone_from_slice: Will not implmented, not possible in Dart

// // contains

//   /// Copies the elements from src into self.
//   /// The length of src must be the same as self.
//   void copyFromSlice(Slice<T> src) {
//     for (var i = src._slice.start, j = _slice.start;
//         i < src._slice.end && j < _slice.end;
//         i++, j++) {
//       _slice.list[j] = src._slice.list[i];
//     }
//   }

// // copy_within: //todo
// // ends_with: //todo
// // eq_ignore_ascii_case: Will not implmented, not possible in Dart
// // escape_ascii: Will not implmented, not possible in Dart
// // fill: //todo
// // fill_with: //todo
// // first: //todo
// // first_chunk: //todo
// // first_chunk_mut: Will not implmented, covered by first_chunk
// // first_mut: Will not implmented, covered by first
// // flatten: //todo, but will have to return a new list
// // flatten_mut: Will not implmented, covered by flatten

//   Option<T> get(int index) {
//     if (index < 0 || index >= _slice.end - _slice.start) {
//       return None();
//     }
//     return Some(this[index]);
//   }

// // get_many: //todo `get_many` name over `get_many_mut`
// // get_many_mut: Will not implmented, covered by get_many
// // get_many_unchecked: //todo `get_many_unchecked` name over `get_many_unchecked_mut`
// // get_many_unchecked_mut: Will not implmented, covered by get_many_unchecked
// // get_mut: Will not implmented, mut the same as get

//   /// Returns the element at the given index without doing bounds checking.
//   getUnchecked(int index) => this[index];

// // get_unchecked_mut: Will not implmented, mut the same as get_unchecked
// // group_by: //todo
// // group_by_mut: Will not implmented, covered by group_by
// // is_ascii: Will not implmented, not possible in Dart

// bool isEmpty() => _slice.start == _slice.end;

// // is_sorted: //todo, use extension method on comparable

// bool isSortedBy(Comparator<T> compare) {
//   for (var i = _slice.start; i < _slice.end - 1; i++) {
//     if (compare(_slice.list[i], _slice.list[i + 1]) > 0) {
//       return false;
//     }
//   }
//   return true;
// }

// // is_sorted_by_key: //todo, use extension method on comparable

//   RIterator<T> iter() => RIterator<T>.fromSlice(this);

// // iter_mut: Will not implmented, mut the same as iter

//   /// Returns the last element of the slice, or `None` if it is empty.
//   Option<T> last() {
//     if (isEmpty()) {
//       return None();
//     }
//     return Some(this[_slice.end - 1]);
//   }

// // last_chunk: //todo
// // last_chunk_mut: Will not implmented, covered by last_chunk
// // last_mut: Will not implmented, covered by last

//   /// Returns the length of the slice.
//   int len() => _slice.start - _slice.end;

// // make_ascii_lowercase: Will not implmented, not possible in Dart
// // make_ascii_uppercase: Will not implmented, not possible in Dart
// // partition_dedup: //todo
// // partition_dedup_by: //todo
// // partition_dedup_by_key: //todo
// // partition_point: //todo
// // rchunks: //todo
// // rchunks_exact: //todo
// // rchunks_exact_mut: Will not implmented, covered by rchunks_exact
// // rchunks_mut: Will not implmented, covered by rchunks

// /// Reverses the order of elements in the slice, in place.
// void reverse() {
//   for (var i = _slice.start, j = _slice.end - 1; i < j; i++, j--) {
//     var temp = _slice.list[i];
//     _slice.list[i] = _slice.list[j];
//     _slice.list[j] = temp;
//   }
// }

// // rotate_left: //todo
// // rotate_right: //todo
// // rsplit: //todo
// // rsplit_array_mut
// // rsplit_array_ref
// // rsplit_mut: 
// // rsplit_once
// // rsplitn
// // rsplitn_mut
// // select_nth_unstable
// // select_nth_unstable_by
// // select_nth_unstable_by_key
// // sort_floats
// // sort_floats
// // sort_unstable
// // sort_unstable_by
// // sort_unstable_by_key
// // split
// // split_array_mut
// // split_array_ref
// // split_at
// // split_at_mut
// // split_at_mut_unchecked
// // split_at_unchecked
// // split_first
// // split_first_chunk
// // split_first_chunk_mut
// // split_first_mut
// // split_inclusive
// // split_inclusive_mut
// // split_last
// // split_last_chunk
// // split_last_chunk_mut
// // split_last_mut
// // split_mut
// // split_once
// // splitn
// // splitn_mut
// // starts_with
// // strip_prefix
// // strip_suffix
// // swap
// // swap_unchecked
// // swap_with_slice

//   /// Returns a new slice of this slice until to, and removes those elements from this slice.
//   /// Returns None and does not modify the slice if the given range is out of bounds.
//   Option<Slice<T>> takeStart(int to){
//     if(to < 0 || to > _slice.end - _slice.start){
//       return None();
//     }
//     var slice = Slice<T>(_slice.list, _slice.start, _slice.start + to);
//     _slice.start += to;
//     return Some(slice);
//   }

//   /// Returns a new slice of this slice from the end, and removes those elements from this slice.
//   /// Returns None and does not modify the slice if the given range is out of bounds.
//   Option<Slice<T>> takeEnd(int from){
//     if(from < 0 || from > _slice.end - _slice.start){
//       return None();
//     }
//     var slice = Slice<T>(_slice.list, _slice.end - from, _slice.end);
//     _slice.end -= from;
//     return Some(slice);
//   }



// // take_first
// // take_first_mut
// // take_last
// // take_last_mut
// // take_mut
// // trim_ascii
// // trim_ascii_end
// // trim_ascii_start
// // windows

//   T operator [](int index) => _slice.list[index + _slice.start];

//   void operator []=(int index, T value) => _slice.list[index + _slice.start] = value;
// }


/// A contiguous sequence of elements in a [Iterable]. Slices are a view into a list without allocating a new list, and do not own their own data.
/// Be careful with slices, as modifying the size of the original list can cause the slices range to change,
/// but the slice will not throw an exception
// ignore: library_private_types_in_public_api
final class Slice<T> {
  int _start;
  int get start => _start;
  int _end;
  int get end => _end;
  final List<T> _list;
  List<T> get list => _list;

  Slice(this._list, this._start, this._end): assert(_start >= 0 && _end <= _list.length, "Index out of bounds");

  Slice.fromList(this._list) : _start = 0, _end = _list.length;

// align_to: Will not implmented, not possible in Dart
// align_to_mut: Will not implmented, not possible in Dart
// array_chunks: //todo
// array_chunks_mut: Will not implmented, covered by array_chunks
// array_windows: //todo
// as_ascii: Will not implmented, not possible in Dart
// as_ascii_unchecked: Will not implmented, not possible in Dart
// as_bytes: Will not implmented, not possible in Dart
// as_chunks: //todo
// as_chunks_mut: Will not implmented, covered by as_chunks
// as_chunks_unchecked: //todo
// as_chunks_unchecked_mut: Will not implmented, covered by as_chunks_unchecked
// as_mut_ptr: Will not implmented, not possible in Dart
// as_mut_ptr_range: Will not implmented, not possible in Dart
// as_ptr: Will not implmented, not possible in Dart
// as_ptr_range: Will not implmented, not possible in Dart
// as_rchunks: //todo
// as_rchunks_mut: Will not implmented, covered by as_rchunks
// as_simd: //todo
// as_simd_mut: Will not implmented, covered by as_simd
// as_str: Will not implmented, not possible in Dart
// binary_search: //todo
// binary_search_by: //todo
// binary_search_by_key: //todo
// chunks: //todo
// chunks_exact: //todo
// chunks_exact_mut: Will not implmented, covered by chunks_exact
// chunks_mut: Will not implmented, covered by chunks
// clone_from_slice: Will not implmented, not possible in Dart

// contains

  /// Copies the elements from src into self.
  /// The length of src must be the same as self.
  void copyFromSlice(Slice<T> src) {
    for (var i = src._start, j = _start;
        i < src._end && j < _end;
        i++, j++) {
      _list[j] = src._list[i];
    }
  }

// copy_within: //todo
// ends_with: //todo
// eq_ignore_ascii_case: Will not implmented, not possible in Dart
// escape_ascii: Will not implmented, not possible in Dart
// fill: //todo
// fill_with: //todo
// first: //todo
// first_chunk: //todo
// first_chunk_mut: Will not implmented, covered by first_chunk
// first_mut: Will not implmented, covered by first
// flatten: //todo, but will have to return a new list
// flatten_mut: Will not implmented, covered by flatten

  Option<T> get(int index) {
    if (index < 0 || index >= _end - _start) {
      return None();
    }
    return Some(this[index]);
  }

// get_many: //todo `get_many` name over `get_many_mut`
// get_many_mut: Will not implmented, covered by get_many
// get_many_unchecked: //todo `get_many_unchecked` name over `get_many_unchecked_mut`
// get_many_unchecked_mut: Will not implmented, covered by get_many_unchecked
// get_mut: Will not implmented, mut the same as get

  /// Returns the element at the given index without doing bounds checking.
  getUnchecked(int index) => this[index];

// get_unchecked_mut: Will not implmented, mut the same as get_unchecked
// group_by: //todo
// group_by_mut: Will not implmented, covered by group_by
// is_ascii: Will not implmented, not possible in Dart

bool isEmpty() => _start == _end;

// is_sorted: //todo, use extension method on comparable

bool isSortedBy(Comparator<T> compare) {
  for (var i = _start; i < _end - 1; i++) {
    if (compare(_list[i], _list[i + 1]) > 0) {
      return false;
    }
  }
  return true;
}

// is_sorted_by_key: //todo, use extension method on comparable

  RIterator<T> iter() => RIterator<T>.fromSlice(this);

// iter_mut: Will not implmented, mut the same as iter

  /// Returns the last element of the slice, or `None` if it is empty.
  Option<T> last() {
    if (isEmpty()) {
      return None();
    }
    return Some(this[_end - 1]);
  }

// last_chunk: //todo
// last_chunk_mut: Will not implmented, covered by last_chunk
// last_mut: Will not implmented, covered by last

  /// Returns the length of the slice.
  int len() => _start - _end;

// make_ascii_lowercase: Will not implmented, not possible in Dart
// make_ascii_uppercase: Will not implmented, not possible in Dart
// partition_dedup: //todo
// partition_dedup_by: //todo
// partition_dedup_by_key: //todo
// partition_point: //todo
// rchunks: //todo
// rchunks_exact: //todo
// rchunks_exact_mut: Will not implmented, covered by rchunks_exact
// rchunks_mut: Will not implmented, covered by rchunks

/// Reverses the order of elements in the slice, in place.
void reverse() {
  for (var i = _start, j = _end - 1; i < j; i++, j--) {
    var temp = _list[i];
    _list[i] = _list[j];
    _list[j] = temp;
  }
}

// rotate_left: //todo
// rotate_right: //todo
// rsplit: //todo
// rsplit_array_mut
// rsplit_array_ref
// rsplit_mut: 
// rsplit_once
// rsplitn
// rsplitn_mut
// select_nth_unstable
// select_nth_unstable_by
// select_nth_unstable_by_key
// sort_floats
// sort_floats
// sort_unstable
// sort_unstable_by
// sort_unstable_by_key
// split
// split_array_mut
// split_array_ref
// split_at
// split_at_mut
// split_at_mut_unchecked
// split_at_unchecked
// split_first
// split_first_chunk
// split_first_chunk_mut
// split_first_mut
// split_inclusive
// split_inclusive_mut
// split_last
// split_last_chunk
// split_last_chunk_mut
// split_last_mut
// split_mut
// split_once
// splitn
// splitn_mut
// starts_with
// strip_prefix
// strip_suffix
// swap
// swap_unchecked
// swap_with_slice

  /// Returns a new slice of this slice until to, and removes those elements from this slice.
  /// Returns None and does not modify the slice if the given range is out of bounds.
  Option<Slice<T>> takeStart(int to){
    if(to < 0 || to > _end - _start){
      return None();
    }
    var slice = Slice<T>(_list, _start, _start + to);
    _start += to;
    return Some(slice);
  }

  /// Returns a new slice of this slice from the end, and removes those elements from this slice.
  /// Returns None and does not modify the slice if the given range is out of bounds.
  Option<Slice<T>> takeEnd(int from){
    if(from < 0 || from > _end - _start){
      return None();
    }
    var slice = Slice<T>(_list, _end - from, _end);
    _end -= from;
    return Some(slice);
  }



// take_first
// take_first_mut
// take_last
// take_last_mut
// take_mut
// trim_ascii
// trim_ascii_end
// trim_ascii_start
// windows

  T operator [](int index) => _list[index + _start];

  void operator []=(int index, T value) => _list[index + _start] = value;
}