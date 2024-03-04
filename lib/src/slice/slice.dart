import 'package:rust_core/option.dart';
import 'package:rust_core/iter.dart';
import 'package:rust_core/result.dart';

/// An iterator over the elements of a [Slice].
final class SliceIterator<T> implements Iterator<T> {
  final Slice<T> _slice;
  int _index;

  SliceIterator(this._slice, this._index);

  @override
  bool moveNext() {
    _index++;
    return _index < _slice._end;
  }

  @override
  T get current => _slice._list[_index];
}

/// A contiguous sequence of elements in a [List]. Slices are a view into a list without allocating and copying to a new list,
/// as such, they do not own their own data.
/// Note: Shrinking the original list can cause the slices range to become invalid, which may cause an exception.
final class Slice<T> extends Iterable<T> {
  int _start;

  /// The start index, inclusive.
  int get start => _start;
  int _end;

  /// The end index, exclusive.
  int get end => _end;
  final List<T> _list;
  List<T> get list => _list;

  Slice(this._list, this._start, this._end)
      : assert(_start >= 0 && _end <= _list.length, "Index out of bounds");

  Slice.fromList(List<T> list) : this(list, 0, list.length);

  @override
  bool operator ==(Object other) {
    return (other is Slice<T> &&
            other._start == _start &&
            other._end == _end &&
            other._list == _list) ||
        (other is List<T> && other.length == _end && _start == 0 && _list == other);
  }

  @override
  int get hashCode => _list.hashCode ^ _start.hashCode ^ _end.hashCode;

  @override
  String toString() {
    return toList().toString();
  }

  @override
  Iterator<T> get iterator => SliceIterator(this, _start - 1);

  //************************************************************************//

// align_to: Will not implement, not possible in Dart
// align_to_mut: Will not implement, not possible in Dart
// array_chunks: //todo
// array_chunks_mut: Will not implement, covered by array_chunks
// array_windows: //todo
// as_ascii: Will not implement, not possible in Dart
// as_ascii_unchecked: Will not implement, not possible in Dart
// as_bytes: Will not implement, not possible in Dart
// as_chunks: //todo
// as_chunks_mut: Will not implement, covered by as_chunks
// as_chunks_unchecked: //todo
// as_chunks_unchecked_mut: Will not implement, covered by as_chunks_unchecked
// as_mut_ptr: Will not implement, not possible in Dart
// as_mut_ptr_range: Will not implement, not possible in Dart
// as_ptr: Will not implement, not possible in Dart
// as_ptr_range: Will not implement, not possible in Dart
// as_rchunks: //todo
// as_rchunks_mut: Will not implement, covered by as_rchunks
// as_simd: //todo
// as_simd_mut: Will not implement, covered by as_simd
// as_str: Will not implement, not possible in Dart
// binary_search: //todo
// binary_search_by: //todo
// binary_search_by_key: //todo
// chunks: //todo
// chunks_exact: //todo
// chunks_exact_mut: Will not implement, covered by chunks_exact
// chunks_mut: Will not implement, covered by chunks
// clone_from_slice: Will not implement, not possible in Dart

// contains: Implemented by Iterable.contains

  /// Copies the elements from src into self.
  /// The length of src must be the same as self.
  void copyFromSlice(Slice<T> src) {
    for (var i = src._start, j = _start; i < src._end && j < _end; i++, j++) {
      _list[j] = src._list[i];
    }
  }

// copy_within: //todo

  /// Returns true if needle is a suffix of the slice.
  bool endsWith(Slice<T> needle){
    if (needle._end - needle._start > _end - _start) {
      return false;
    }
    for (var i = 0; i < needle._end - needle._start; i++) {
      if (_list[_end - i - 1] != needle._list[needle._end - i - 1]) {
        return false;
      }
    }
    return true;
  }

// eq_ignore_ascii_case: Will not implement, not possible in Dart
// escape_ascii: Will not implement, not possible in Dart
// fill: //todo
// fill_with: //todo

  @override
  T get first => list[_start];

  Option<T> get firstOrOption {
    if (isEmpty) {
      return None;
    }
    return Some(list[_start]);
  }

// first_chunk: //todo
// first_chunk_mut: Will not implement, covered by first_chunk
// first_mut: Will not implement, covered by first
// flatten: //todo, but will have to return a new list
// flatten_mut: Will not implement, covered by flatten

  Option<T> get(int index) {
    if (index < 0 || index >= _end - _start) {
      return None;
    }
    return Some(this[index]);
  }

// get_many: //todo `get_many` name over `get_many_mut`
// get_many_mut: Will not implement, covered by get_many
// get_many_unchecked: //todo `get_many_unchecked` name over `get_many_unchecked_mut`
// get_many_unchecked_mut: Will not implement, covered by get_many_unchecked
// get_mut: Will not implement, mut the same as get

  /// Returns the element at the given index without doing bounds checking.
  getUnchecked(int index) => this[index];

// get_unchecked_mut: Will not implement, mut the same as get_unchecked
// group_by: //todo
// group_by_mut: Will not implement, covered by group_by
// is_ascii: Will not implement, not possible in Dart

  @override
  bool get isEmpty => _start == _end;

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

// iter_mut: Will not implement, mut the same as iter

  /// Returns the last element of the slice, can throw.
  @override
  T get last {
    return list[_end - 1];
  }

  /// Returns the last element of the slice, or None if it is empty.
  Option<T> get lastOrOption {
    if (isEmpty) {
      return None;
    }
    return Some(list[_end - 1]);
  }

// last_chunk: //todo
// last_chunk_mut: Will not implement, covered by last_chunk
// last_mut: Will not implement, covered by last

  /// Returns the length of the slice.
  int len() => _start - _end;

// make_ascii_lowercase: Will not implement, not possible in Dart
// make_ascii_uppercase: Will not implement, not possible in Dart
// partition_dedup: //todo
// partition_dedup_by: //todo
// partition_dedup_by_key: //todo
// partition_point: //todo
// rchunks: //todo
// rchunks_exact: //todo
// rchunks_exact_mut: Will not implement, covered by rchunks_exact
// rchunks_mut: Will not implement, covered by rchunks

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

  /// Returns an iterator over subslices separated by elements that match pred,
  /// starting at the end of the slice and working backwards.
  /// The matched element is not contained in the subslices.
  RIterator<Slice<T>> rsplit(bool Function(T) pred) {
    return RIterator(_rsplitHelper(pred));
  }

  Iterable<Slice<T>> _rsplitHelper(bool Function(T) pred) sync* {
    var start = _end - 1;
    var end = _end - 1;
    while (start >= _start) {
      if (pred(_list[start])) {
        yield Slice(_list, start + 1, end + 1);
        end = start - 1;
      }
      start--;
    }
    yield Slice(_list, _start, end + 1);
  }

  /// Divides one slice into a slice and a remainder slice at an index from the end.
  /// The slice will contain all indices from [0, len - N) (excluding the index N itself) and the second slice will contain all
  /// indices from [len - N, len) (excluding the index len itself).
  (Slice<T>, Slice<T>) rsplitAt(int index) {
    assert(index >= 0 && index <= _end - _start, "Index out of bounds");
    return (Slice(_list, _start, _end - index), Slice(_list, _end - index, _end));
  }

// rsplit_array: Will not implement, would need to allocate another list for the Dart version
// rsplit_array_mut: Will not implement, see above
// rsplit_array_ref: Will not implement, see above
// rsplit_mut: Will not implement, implemented by rsplit

  /// Splits the slice on the last element that matches the specified predicate.
  /// If any matching elements are resent in the slice, returns the prefix before the match and suffix after.
  /// The matching element itself is not included. If no elements match, returns None.
  Option<(Slice<T>, Slice<T>)> rsplitOnce(bool Function(T) pred) {
    var index = _end - 1;
    while (index >= _start) {
      if (pred(_list[index])) {
        return Some((Slice(_list, _start, index), Slice(_list, index + 1, _end)));
      }
      index--;
    }
    return None;
  }

// rsplitn: //todo priority low
// rsplitn_mut: Implemented by above
// select_nth_unstable: //todo priority low
// select_nth_unstable_by: // todo priority low
// select_nth_unstable_by_key: //todo priority low
// sort_floats: Implmented by sort_unstable
// sort_floats: Implmented by sort_unstable
// sort_unstable: Implemented in extension
// sort_unstable_by: Implmented in extension
// sort_unstable_by_key: Implmented in extension

  /// Returns an iterator over subslices separated by elements that match pred. 
  /// The matched element is not contained in the subslices. see [splitInclusive] also.
  RIterator<Slice<T>> split(bool Function(T) pred) {
    return RIterator(_splitHelper(pred));
  }

  /// Returns an iterator over subslices separated by elements that match pred.
  /// The matched element is not contained in the subslices.
  Iterable<Slice<T>> _splitHelper(bool Function(T) pred) sync* {
    var start = _start;
    var end = _start;
    while (end < _end) {
      if (pred(_list[end])) {
        yield Slice(_list, start, end);
        start = end + 1;
      }
      end++;
    }
    yield Slice(_list, start, end);
  }

// split_array_mut: Will not implement, would need to allocate another list for the Dart version
// split_array_ref: see above

  /// Divides one mutable slice into a slice and a remainder slice at an index.
  /// The slice will contain all indices from [0, N) (excluding the index N itself)
  /// and the second slice will contain all indices from [N, len) (excluding the index len itself).
  (Slice<T>, Slice<T>) splitAt(int index) {
    assert(index >= 0 && index <= _end - _start, "Index out of bounds");
    return (Slice(_list, _start, _start + index), Slice(_list, _start + index, _end));
  }

// split_at_mut: Implemented by splitAt
// split_at_mut_unchecked: Implemented by splitAt
// split_at_unchecked: Implemented by splitAt

  /// Returns the first and all the rest of the elements of the slice, or None if it is empty.
  Option<(T, Slice<T>)> splitFirst() {
    if (isEmpty) {
      return None;
    }
    var element = _list[_start];
    _start++;
    return Some((element, Slice(_list, _start, _end)));
  }

// split_first_chunk: Will not implement, not possible in Dart needs const generics, otherwise it is just `spitAt` implementation
// split_first_chunk_mut: Will not implement, see above
// split_first_mut: Will not implement, implemented by `splitFirst`

  /// Returns an iterator over subslices separated by elements that match pred. 
  /// The matched element is contained in the end of the previous subslice as a terminator. see [split] also.
  RIterator<Slice<T>> splitInclusive(bool Function(T) pred) {
    return RIterator(_splitInclusiveHelper(pred));
  }

  Iterable<Slice<T>> _splitInclusiveHelper(bool Function(T) pred) sync* {
    var start = _start;
    var end = _start;
    while (end < _end) {
      if (pred(_list[end])) {
        yield Slice(_list, start, end + 1);
        start = end + 1;
      }
      end++;
    }
    yield Slice(_list, start, end);
  }

// split_inclusive_mut: Implemented by above

  /// Returns the last and all the rest of the elements of the slice, or None if it is empty.
  Option<(T, Slice<T>)> splitLast() {
    if (isEmpty) {
      return None;
    }
    var element = _list[_end - 1];
    _end--;
    return Some((element, Slice(_list, _start, _end)));
  }

// split_last_chunk: Will not implement, not possible in Dart needs const generics
// split_last_chunk_mut: Will not implement, not possible in Dart needs const generics
// split_last_mut: Implemented by `splitLast`
// split_mut: Implemented by `split`

  /// Splits the slice on the first element that matches the specified predicate.
  /// If any matching elements are resent in the slice, returns the prefix before the match and suffix after.
  ///  The matching element itself is not included. If no elements match, returns None.
  Option<(Slice<T>, Slice<T>)> splitOnce(bool Function(T) pred) {
    var index = _start;
    while (index < _end) {
      if (pred(_list[index])) {
        return Some((Slice(_list, _start, index), Slice(_list, index + 1, _end)));
      }
      index++;
    }
    return None;
  }

  /// Returns an iterator over subslices separated by elements that match pred, limited to returning at most n items.
  /// e.g. n == 1 will return the whole slice.
  /// The matched element is not contained in the subslices.
  /// The last element returned, if any, will contain the remainder of the slice.
  RIterator<Slice<T>> splitn(int n, bool Function(T) pred){
    assert(n > 0, "n must be positive");
    if(n < 1){
      return RIterator(Iterable.empty());
    }
    return RIterator(_splitnHelper(n, pred));
  }

  Iterable<Slice<T>> _splitnHelper(int n, bool Function(T) pred) sync* {
    var start = _start;
    var end = _start;
    var count = 1;
    while (end < _end && count < n) {
      if (pred(_list[end])) {
        yield Slice(_list, start, end);
        start = end + 1;
        count++;
      }
      end++;
    }
    yield Slice(_list, start, _end);
  }
  


// splitn_mut: Implemented by above

  /// Returns true if needle is a prefix of the slice.
  bool startsWith(Slice<T> needle) {
    if (needle._end - needle._start > _end - _start) {
      return false;
    }
    for (var i = 0; i < needle._end - needle._start; i++) {
      if (_list[i + _start] != needle._list[i + needle._start]) {
        return false;
      }
    }
    return true;
  }

  /// Returns a subslice with the prefix removed. Returns none if the prefix is not present.
  Option<Slice<T>> stripPrefix(Slice<T> prefix) {
    if (startsWith(prefix)) {
      return Some(Slice(_list, _start + prefix._end - prefix._start, _end));
    }
    return None;
  }


  Option<Slice<T>> stripSuffix(Slice<T> suffix) {
    if (endsWith(suffix)) {
      return Some(Slice(_list, _start, _end - suffix._end + suffix._start));
    }
    return None;
  }

  /// Swaps two elements in the slice. Will throw if the indices are out of bounds.
  void swap(int i, int j) {
    var temp = _list[i + _start];
    _list[i + _start] = _list[j + _start];
    _list[j + _start] = temp;
  }

// swap_unchecked: Will not implement, not possible in Dart

  /// Swaps all elements in this with those in other.
  /// The length of other must be the same as this.
  /// Will throw if the length of other is not the same as this.
  void swapWithSlice(Slice<T> other) {
    assert(_end - _start == other._end - other._start, "Slices must be the same length");
    for (var i = 0; i < _end - _start; i++) {
      var temp = _list[i + _start];
      _list[i + _start] = other._list[i + other._start];
      other._list[i + other._start] = temp;
    }
  }

  /// Returns a new slice of this slice until to, and removes those elements from this slice.
  /// Returns None and does not modify the slice if the given range is out of bounds.
  Option<Slice<T>> takeStart(int to) {
    if (to < 0 || to > _end - _start) {
      return None;
    }
    var slice = Slice<T>(_list, _start, _start + to);
    _start += to;
    return Some(slice);
  }

  /// Returns a new slice of this slice from the end, and removes those elements from this slice.
  /// Returns None and does not modify the slice if the given range is out of bounds.
  Option<Slice<T>> takeEnd(int from) {
    if (from < 0 || from > _end - _start) {
      return None;
    }
    var slice = Slice<T>(_list, _end - from, _end);
    _end -= from;
    return Some(slice);
  }

  // Returns the first element of this slice, and removes it from this slice.
  Option<T> takeFirst() {
    if (isEmpty) {
      return None;
    }
    var element = _list[_start];
    _start++;
    return Some(element);
  }

// take_first_mut: Will not implement, mut the same as take_first

  // Returns the last element of this slice, and removes it from this slice.
  Option<T> takeLast() {
    if (isEmpty) {
      return None;
    }
    var element = _list[_end - 1];
    _end--;
    return Some(element);
  }

// take_last_mut: Will not implement, mut the same as take_last
// take_mut: Will not implement, same as takeEnd and takeStart
// trim_ascii: Will not implement, not possible in Dart
// trim_ascii_end: Will not implement, not possible in Dart
// trim_ascii_start: Will not implement, not possible in Dart

  /// growable param is ignored, but need to satisfy the interface.
  @override
  List<T> toList({bool growable = true}) {
    return _list.sublist(_start, _end);
  }

  RIterator<Slice<T>> windows(int size) {
    assert(size > 0, "Size must be positive");
    assert(size <= _end - _start, "Size must be less than or equal to the length of the slice");
    return RIterator(Iterable.generate(
        _end - _start - size + 1, (i) => Slice(_list, _start + i, _start + i + size)));
  }

  T operator [](int index) => _list[index + _start];

  void operator []=(int index, T value) => _list[index + _start] = value;
}
