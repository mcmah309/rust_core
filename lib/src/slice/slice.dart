// ignore_for_file: avoid_renaming_method_parameters

import 'package:rust_core/option.dart';
import 'package:rust_core/iter.dart';
import 'package:rust_core/result.dart';
import 'package:rust_core/array.dart';
import 'package:rust_core/slice.dart';
import 'package:rust_core/src/slice/errors.dart';

part 'slice_extensions.dart';

/// An iterator over the elements of a [Slice].
final class SliceIterator<T> implements Iterator<T> {
  final Slice<T> _slice;
  int _index;

  SliceIterator(this._slice, this._index);

  @override
  @pragma("vm:prefer-inline")
  bool moveNext() {
    if (_index + 1 < _slice._end) {
      _index++;
      return true;
    }
    return false;
  }

  @override
  @pragma("vm:prefer-inline")
  T get current => _slice._list[_index];
}

/// A contiguous sequence of elements in a [List]. Slices are a view into a list without allocating and copying to a new list,
/// as such, they do not own their own data.
/// Note: Shrinking the original list can cause the slices range to become invalid, which may cause an exception or unintended behavior.
final class Slice<T> implements Iterable<T> {
  int _start;
  int _end;
  final List<T> _list;

  @pragma("vm:prefer-inline")
  Slice(this._list, this._start, this._end)
      : assert(_start >= 0 && _end <= _list.length, "Index out of bounds");

  @pragma("vm:prefer-inline")
  Slice.fromList(List<T> list) : this(list, 0, list.length);

  @pragma("vm:prefer-inline")
  Slice.fromSlice(Slice<T> slice, [int start = 0, int? end])
      : this(slice._list, slice._start + start, end == null ? slice._end : slice._start + end);

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
  @pragma("vm:prefer-inline")
  Iterator<T> get iterator => SliceIterator(this, _start - 1);

  //************************************************************************//

// align_to: Will not implement, not possible in Dart
// align_to_mut: Will not implement, not possible in Dart
// array_chunks: Will not implement, covered by iter's array chunks
// array_chunks_mut: Will not implement, covered by array_chunks
// array_windows: Will not implement, not possible in Dart, would need an allocation for the Dart Array version. Uses `windows` instead.
// as_ascii: Will not implement, not possible in Dart
// as_ascii_unchecked: Will not implement, not possible in Dart
// as_bytes: Will not implement, not possible in Dart

  /// Splits the slice into a slice of N-element arrays, starting at the beginning of the slice, and a remainder slice with length strictly less than N.
  (Arr<Arr<T>> chunks, Arr<T> remainder) asChunks(int n) {
    // Dev Note: No need to a panic in release mode, `Arr.generate` already does a check
    assert(n > 0, "'n' must be positive");
    final length = len();
    final numOfChunks = length ~/ n;
    final Arr<Arr<T?>> chunks = Arr.generate(numOfChunks, (i) => Arr(null, n));
    for (var i = 0; i < chunks.len(); i++) {
      for (var j = 0; j < n; j++) {
        chunks[i][j] = this[i * n + j];
      }
      chunks[i] = chunks[i].cast<T>();
    }
    final remainderLength = length % n;
    var remainder = Arr<T?>(null, remainderLength);
    for (var i = 0; i < remainderLength; i++) {
      remainder[i] = this[i + chunks.len() * n];
    }
    return (chunks.cast<Arr<T>>(), remainder.cast<T>());
  }

// as_chunks_mut: Will not implement, covered by as_chunks
// as_chunks_unchecked: Will not implement, covered by as_chunks
// as_chunks_unchecked_mut: Will not implement, covered by as_chunks_unchecked
// as_mut_ptr: Will not implement, not possible in Dart
// as_mut_ptr_range: Will not implement, not possible in Dart
// as_ptr: Will not implement, not possible in Dart
// as_ptr_range: Will not implement, not possible in Dart

  /// Splits the slice into a slice of N-element arrays, starting at the end of the slice,
  /// and a remainder slice with length strictly less than N
  (Arr<T> remainder, Arr<Arr<T>> chunks) asRchunks(int n) {
    // Dev Note: No need to a panic in release mode, `Arr()` already does a check
    assert(n > 0, "'n' must be positive");
    final length = len();
    final remainderLength = length % n;
    var remainder = Arr<T?>(null, remainderLength);
    for (var i = 0; i < remainderLength; i++) {
      remainder[i] = this[i];
    }
    final numOfChunks = length ~/ n;
    final Arr<Arr<T?>> chunks = Arr.generate(numOfChunks, (i) => Arr(null, n));
    for (var i = 0; i < chunks.len(); i++) {
      for (var j = 0; j < n; j++) {
        chunks[i][j] = this[remainderLength + i * n + j];
      }
      chunks[i] = chunks[i].cast<T>();
    }
    return (remainder.cast<T>(), chunks.cast<Arr<T>>());
  }

// as_rchunks_mut: Will not implement, covered by as_rchunks
// as_simd: Will not implement, not possible in Dart
// as_simd_mut: Will not implement, covered by as_simd
// as_str: Will not implement, not possible in Dart
// binary_search: implemented in extension

  /// Binary searches this slice with a comparator function. See [SliceOnComparableSliceExtension.binarySearch] for more.
  Result<int, int> binarySearchBy(int Function(T) comparator) {
    int left = 0;
    int right = this.length - 1;

    while (left <= right) {
      int mid = left + ((right - left) >> 1);
      int comp = comparator(this[mid]);

      if (comp == 0) {
        return Ok(mid);
      } else if (comp < 0) {
        left = mid + 1;
      } else {
        right = mid - 1;
      }
    }

    // If not found, return the index where it can be inserted to maintain sorted order.
    return Err(left);
  }

  /// Binary searches this slice with a key extraction function. See [SliceOnComparableSliceExtension.binarySearch] for more.
  Result<int, int> binarySearchByKey<K extends Comparable>(
      K key, K Function(T) keyExtractor) {
    int left = 0;
    int right = length - 1;

    while (left <= right) {
      int mid = left + ((right - left) >> 1);
      K midKey = keyExtractor(this[mid]);
      int comp = midKey.compareTo(key);

      if (comp == 0) {
        return Ok(mid);
      } else if (comp < 0) {
        left = mid + 1;
      } else {
        right = mid - 1;
      }
    }

    // If not found, return the index where it can be inserted to maintain sorted order.
    return Err(left);
  }

// chunks: Will not implement, covered by array_chunks
// chunks_exact: Will not implement, covered by array_chunks
// chunks_exact_mut: Will not implement, covered by array_chunks
// chunks_mut: Will not implement, covered by array_chunks
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
  bool endsWith(Slice<T> needle) {
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

  /// Fills this slice with [value].
  void fill(T value) {
    for (var i = _start; i < _end; i++) {
      _list[i] = value;
    }
  }

  /// Fills this slice with the value return by calling [f] repeatedly.
  void fillWith(T Function() f) {
    for (var i = _start; i < _end; i++) {
      _list[i] = f();
    }
  }

  @override
  T get first => _list[_start];

  Option<T> get firstOrOption {
    if (isEmpty) {
      return None;
    }
    return Some(_list[_start]);
  }

// first_chunk: Will not implement, not possible in Dart, needs const generics
// first_chunk_mut: Will not implement, covered by first_chunk
// first_mut: Will not implement, covered by first
// flatten: Will not implement, not possible in Dart, needs const generics
// flatten_mut: Will not implement, covered by flatten

  Option<T> get(int index) {
    if (index < 0 || index >= _end - _start) {
      return None;
    }
    return Some(this[index]);
  }

  /// Returns mutable references to many indices at once.
  /// Returns an error if any index is out-of-bounds.
  Result<Arr<T>, GetManyError> getMany(List<int> indices) {
    if (indices.length > _end - _start) {
      return const Err(GetManyErrorTooManyIndices());
    }
    if (indices.isEmpty) {
      return Ok(Arr.empty());
    }
    var array = Arr(this.first, indices.length);
    for (final (int i, int index) in indices.iter().enumerate()) {
      if (index < _start || index >= _end) {
        return const Err(GetManyErrorRequestedIndexOutOfBounds());
      }
      array[i] = this[index];
    }
    return Ok(array);
  }

// get_many_mut: Will not implement, covered by get_many

  /// Returns mutable references to many indices at once, without doing any checks.
  Arr<T> getManyUnchecked(List<int> indices) {
    assert(indices.length <= _end - _start,
        "The number of indices must be less than or equal to the length of the slice");
    if (indices.isEmpty) {
      return Arr.empty();
    }
    assert(isNotEmpty, "Requested indices, but this slice is empty.");
    var array = Arr(this.first, indices.length);
    for (final (int i, int index) in indices.iter().enumerate()) {
      assert(index >= _start && index < _end, "The requiested index out of bounds");
      array[i] = this[index];
    }
    return array;
  }
// get_many_unchecked_mut: Will not implement, covered by get_many_unchecked
// get_mut: Will not implement, mut the same as get

  /// Returns the element at the given index without doing bounds checking.
  getUnchecked(int index) => this[index];

// get_unchecked_mut: Will not implement, mut the same as get_unchecked

  /// Returns an %iterator over the slice producing non-overlapping runs of elements using the predicate to separate them.
  RIterator<Slice<T>> groupBy(bool Function(T, T) compare) {
    return RIterator(_groupByHelper(compare).iterator);
  }

  Iterable<Slice<T>> _groupByHelper(bool Function(T, T) compare) sync* {
    var start = _start;
    var end = _start;
    while (end < _end) {
      if (!compare(_list[start], _list[end])) {
        yield Slice(_list, start, end);
        start = end;
      }
      end++;
    }
    yield Slice(_list, start, end);
  }

// group_by_mut: Will not implement, covered by group_by
// is_ascii: Will not implement, not possible in Dart

  @override
  bool get isEmpty => _start == _end;

  @override
  bool get isNotEmpty => _start != _end;

// is_sorted: Implemented in extension

  /// Checks if the elements of this slice are sorted using the given comparator function.
  bool isSortedBy(Comparator<T> compare) {
    for (var i = _start; i < _end - 1; i++) {
      if (compare(_list[i], _list[i + 1]) > 0) {
        return false;
      }
    }
    return true;
  }

  /// Checks if the elements of this slice are sorted using the given key extraction function.
  bool isSortedByKey<K extends Comparable<K>>(K Function(T) key) {
    for (int i = _start; i < _end - 1; i++) {
      if (key(_list[i]).compareTo(key(_list[i + 1])) > 0) {
        return false;
      }
    }
    return true;
  }

  RIterator<T> iter() => RIterator<T>.fromIterable(this);

// iter_mut: Will not implement, mut the same as iter

  /// Returns the last element of the slice, can throw.
  @override
  @pragma("vm:prefer-inline")
  T get last {
    return _list[_end - 1];
  }

  /// Returns the last element of the slice, or None if it is empty.
  Option<T> get lastOrOption {
    if (isEmpty) {
      return None;
    }
    return Some(_list[_end - 1]);
  }

// last_chunk: //todo
// last_chunk_mut: Will not implement, covered by last_chunk
// last_mut: Will not implement, covered by last

  /// Returns the length of the slice.
  @pragma("vm:prefer-inline")
  int len() => _end - _start;

// make_ascii_lowercase: Will not implement, not possible in Dart
// make_ascii_uppercase: Will not implement, not possible in Dart
// partition_dedup: //todo
// partition_dedup_by: //todo
// partition_dedup_by_key: //todo

  /// Returns the index of the partition point according to the given predicate (the index of the first element of the second partition).
  /// The slice is assumed to be partitioned according to the given predicate. This means that all elements for which the predicate returns
  /// true are at the start of the slice and all elements for which the predicate returns false are at the end.
  /// For example, [7, 15, 3, 5, 4, 12, 6] is partitioned under the predicate x % 2 != 0 (all odd numbers are at the start, all even at the end).
  /// If this slice is not partitioned, the returned result is unspecified and meaningless, as this method performs a kind of binary search.
  int partitionPoint(bool Function(T) predicate) {
    int low = 0;
    int high = length;

    while (low < high) {
      int mid = (low + high) >> 1;
      if (predicate(this[mid])) {
        low = mid + 1;
      } else {
        high = mid;
      }
    }

    return low;
  }

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
    return RIterator(_rsplitHelper(pred).iterator);
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

  /// Sorts the slice with a comparator function, but might not preserve the order of equal elements.
  void sortUnstableBy(int Function(T a, T b) compare) {
    _quickSortBy(this, _start, _end - 1, compare);
  }

  /// Sorts the slice with a key extraction function, but might not preserve the order of equal elements.
  void sortUnstableByKey<K extends Comparable<K>>(K Function(T a) key) {
    _quickSortBy(this, _start, _end - 1, (a, b) => key(a).compareTo(key(b)));
  }

  /// Returns an iterator over subslices separated by elements that match pred.
  /// The matched element is not contained in the subslices. see [splitInclusive] also.
  RIterator<Slice<T>> split(bool Function(T) pred) {
    return RIterator(_splitHelper(pred).iterator);
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
    return RIterator(_splitInclusiveHelper(pred).iterator);
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
  RIterator<Slice<T>> splitn(int n, bool Function(T) pred) {
    assert(n > 0, "n must be positive");
    if (n < 1) {
      return RIterator(<Slice<T>>[].iterator);
    }
    return RIterator(_splitnHelper(n, pred).iterator);
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

  /// Returns an iterator over all contiguous windows of length size. The windows overlap.
  /// If the slice is shorter than size, the iterator returns no values.
  RIterator<Slice<T>> windows(int size) {
    // Dev Note: No need to a panic in release mode, `Iterable.generate` already does a check
    assert(size > 0, "Size must be positive");
    if (size > _end - _start) {
      return RIterator.fromIterable(const []);
    }
    return RIterator(Iterable.generate(
        _end - _start - size + 1, (i) => Slice(_list, _start + i, _start + i + size)).iterator);
  }

  @pragma("vm:prefer-inline")
  T operator [](int index) => _list[index + _start];

  @pragma("vm:prefer-inline")
  void operator []=(int index, T value) => _list[index + _start] = value;

  @pragma("vm:prefer-inline")
  Slice<T> slice([int start = 0, int? end]) {
    return Slice.fromSlice(this, start, end);
  }

  // Iterable: Overriding iterable methods
  //************************************************************************//

  @override
  @pragma("vm:prefer-inline")
  bool any(bool Function(T) f) => _list.getRange(_start, _end).any(f);

  @override
  @pragma("vm:prefer-inline")
  RIterator<U> cast<U>() => RIterator(_list.getRange(_start, _end).cast<U>().iterator);

  @override
  @pragma("vm:prefer-inline")
  bool contains(Object? element) => _list.getRange(_start, _end).contains(element);

  @override
  @pragma("vm:prefer-inline")
  T elementAt(int index) => _list.getRange(_start, _end).elementAt(index);

  @override
  @pragma("vm:prefer-inline")
  bool every(bool Function(T) f) => _list.getRange(_start, _end).every(f);

  @override
  @pragma("vm:prefer-inline")
  RIterator<U> expand<U>(Iterable<U> Function(T) f) =>
      RIterator(_list.getRange(_start, _end).expand(f).iterator);

  @override
  @pragma("vm:prefer-inline")
  T firstWhere(bool Function(T) f, {T Function()? orElse}) =>
      _list.getRange(_start, _end).firstWhere(f, orElse: orElse);

  @override
  @pragma("vm:prefer-inline")
  U fold<U>(U initialValue, U Function(U previousValue, T element) f) =>
      _list.getRange(_start, _end).fold(initialValue, f);

  @override
  @pragma("vm:prefer-inline")
  RIterator<T> followedBy(Iterable<T> other) =>
      RIterator(_list.getRange(_start, _end).followedBy(other).iterator);

  @override
  @pragma("vm:prefer-inline")
  void forEach(void Function(T) f) => _list.getRange(_start, _end).forEach(f);

  @override
  @pragma("vm:prefer-inline")
  String join([String separator = '']) => _list.getRange(_start, _end).join(separator);

  @override
  @pragma("vm:prefer-inline")
  T lastWhere(bool Function(T) f, {T Function()? orElse}) =>
      _list.getRange(_start, _end).lastWhere(f, orElse: orElse);

  @override
  @pragma("vm:prefer-inline")
  int get length => _end - _start;

  @override
  @pragma("vm:prefer-inline")
  RIterator<U> map<U>(U Function(T) f) => RIterator(_list.getRange(_start, _end).map(f).iterator);

  @override
  @pragma("vm:prefer-inline")
  T reduce(T Function(T, T) f) => _list.getRange(_start, _end).reduce(f);

  @override
  @pragma("vm:prefer-inline")
  T get single => _list.getRange(_start, _end).single;

  @override
  @pragma("vm:prefer-inline")
  T singleWhere(bool Function(T) f, {T Function()? orElse}) =>
      _list.getRange(_start, _end).singleWhere(f, orElse: orElse);

  @override
  @pragma("vm:prefer-inline")
  RIterator<T> skip(int count) => RIterator(_list.getRange(_start, _end).skip(count).iterator);

  @override
  @pragma("vm:prefer-inline")
  RIterator<T> skipWhile(bool Function(T) f) =>
      RIterator(_list.getRange(_start, _end).skipWhile(f).iterator);

  @override
  @pragma("vm:prefer-inline")
  RIterator<T> take(int count) => RIterator(_list.getRange(_start, _end).take(count).iterator);

  @override
  @pragma("vm:prefer-inline")
  RIterator<T> takeWhile(bool Function(T) f) =>
      RIterator(_list.getRange(_start, _end).takeWhile(f).iterator);

  /// [growable] is ignore, always returns a growable list.
  @override
  @pragma("vm:prefer-inline")
  List<T> toList({bool growable = true}) => _list.sublist(_start, _end);

  @override
  @pragma("vm:prefer-inline")
  Set<T> toSet() => _list.getRange(_start, _end).toSet();

  @override
  @pragma("vm:prefer-inline")
  RIterator<T> where(bool Function(T) f) =>
      RIterator(_list.getRange(_start, _end).where(f).iterator);

  @override
  @pragma("vm:prefer-inline")
  RIterator<U> whereType<U>() => RIterator(_list.getRange(_start, _end).whereType<U>().iterator);
}
