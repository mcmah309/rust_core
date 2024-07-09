// ignore_for_file: avoid_renaming_method_parameters

import 'dart:math';

import 'package:rust_core/ops.dart';
import 'package:rust_core/option.dart';
import 'package:rust_core/iter.dart';
import 'package:rust_core/panic.dart';
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
final class Slice<T> implements List<T> {
  int _start;
  int _end;
  final List<T> _list;

  @pragma("vm:prefer-inline")
  Slice(this._list, [this._start = 0, int? end])
      : _end = end ?? _list.length,
        assert(_start >= 0 && (end == null || end <= _list.length), "Index out of bounds");

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

  @pragma("vm:prefer-inline")
  Iterable<T> call(RangeBounds range) => range.slice(this);

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
// array_chunks: Will not implement, covered by iter's array_chunks
// array_chunks_mut: Will not implement, covered by array_chunks

  /// Returns an iterator over all contiguous windows of length size. The windows overlap.
  /// If the array is shorter than size, the iterator returns no values.
  /// Panics if size is zero or less.
  RIterator<Arr<T>> arrayWindows(int size) {
    if (size <= 0) {
      panic("window size must be non-zero");
    }
    return RIterator.fromIterable(_arrayWindowsHelper(size));
  }

  Iterable<Arr<T>> _arrayWindowsHelper(int size) sync* {
    final numOfArrays = _end - _start - size + 1;
    for (int i = 0; i < numOfArrays; i++) {
      final start = _start + i;
      yield Arr.generate(size, (index) => _list[start + index]);
    }
  }

// as_ascii: Will not implement, not possible in Dart
// as_ascii_unchecked: Will not implement, not possible in Dart
// as_bytes: Will not implement, not possible in Dart

  /// Splits the slice into a slice of N-element arrays, starting at the beginning of the slice,
  /// and a remainder slice with length strictly less than N.
  /// Panics if [chunkSize] is 0 or less.
  (Arr<Arr<T>> chunks, Arr<T> remainder) asChunks(int chunkSize) {
    if (chunkSize <= 0) {
      panic("'chunkSize' must be positive");
    }
    final length = len();
    final numOfChunks = length ~/ chunkSize;
    final Arr<Arr<T>> chunks = Arr.generate(numOfChunks, (i) {
      return Arr.generate(chunkSize, (j) => getUnchecked(i * chunkSize + j));
    });
    final remainderLength = length % chunkSize;
    var remainder =
        Arr<T>.generate(remainderLength, (i) => getUnchecked(i + chunks.len() * chunkSize));
    return (chunks, remainder);
  }

// as_chunks_mut: Will not implement, covered by as_chunks
// as_chunks_unchecked: Will not implement, covered by as_chunks
// as_chunks_unchecked_mut: Will not implement, covered by as_chunks_unchecked
// as_mut_ptr: Will not implement, not possible in Dart
// as_mut_ptr_range: Will not implement, not possible in Dart
// as_ptr: Will not implement, not possible in Dart
// as_ptr_range: Will not implement, not possible in Dart

  /// Splits the slice into a slice of N-element arrays, starting at the end of the slice,
  /// and a remainder slice with length strictly less than N.
  /// Panics if [chunkSize] is 0 or less.
  (Arr<T> remainder, Arr<Arr<T>> chunks) asRchunks(int chunkSize) {
    if (chunkSize <= 0) {
      panic("'chunkSize' must be positive");
    }
    final length = len();
    final remainderLength = length % chunkSize;
    var remainder = Arr<T>.generate(remainderLength, (i) => getUnchecked(i));
    final numOfChunks = length ~/ chunkSize;
    final Arr<Arr<T>> chunks = Arr.generate(numOfChunks, (i) {
      return Arr.generate(chunkSize, (j) => getUnchecked(remainderLength + i * chunkSize + j));
    });
    return (remainder, chunks);
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
      int comp = comparator(getUnchecked(mid));

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
  Result<int, int> binarySearchByKey<K extends Comparable>(K key, K Function(T) keyExtractor) {
    int left = 0;
    int right = length - 1;

    while (left <= right) {
      int mid = left + ((right - left) >> 1);
      K midKey = keyExtractor(getUnchecked(mid));
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

  /// Returns an iterator over the slice producing non-overlapping runs of elements
  /// using the predicate to separate them.
  /// `[1, 1, 1, 3, 3]` => `[[1, 1, 1], [3, 3]]` for `(a, b) => a == b`
  /// The predicate is called for every pair of consecutive elements.
  RIterator<Slice<T>> chunkBy(bool Function(T, T) compare) {
    return RIterator(_chunkByHelper(compare).iterator);
  }

  Iterable<Slice<T>> _chunkByHelper(bool Function(T, T) compare) sync* {
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

  /// Returns an iterator over [chunkSize] elements of the slice at a time, starting at the beginning of the slice.
  /// The chunks are slices and do not overlap. If [chunkSize] does not divide the length of the slice,
  /// then the last chunk will not have length chunkSize.
  /// Panics if [chunkSize] is 0 or less.
  RIterator<Slice<T>> chunks(int n) {
    return RIterator.fromIterable(_chunksHelper(n));
  }

  @pragma("vm:prefer-inline")
  Iterable<Slice<T>> _chunksHelper(int chunkSize) sync* {
    if (chunkSize <= 0) {
      panic("'chunkSize' must be positive");
    }
    final length = len();
    final numOfChunks = length ~/ chunkSize;
    for (var i = 0; i < numOfChunks; i++) {
      final start = i * chunkSize;
      yield slice(start, start + chunkSize);
    }
    final remainderLength = length % chunkSize;
    if (remainderLength > 0) {
      final start = numOfChunks * chunkSize;
      yield slice(start, start + remainderLength);
    }
  }

// chunks_exact: // todo, need to create an RIterator class that has `remainder()` method
// chunks_exact_mut: Will not implement, covered by chunks_exact
// chunks_mut: Will not implement, covered by chunks
// clone_from_slice: Will not implement, not possible in Dart

// contains: Implemented by Iterable.contains

  /// Copies the elements from src into self.
  /// The length of src must be the same as this.
  void copyFromSlice(Slice<T> src) {
    final length = len();
    final srcLength = src.len();
    if (length != srcLength) {
      panic("Slices must be the same length, this is `$length` and src is `$src");
    }
    for (var i = src._start, j = _start; i < src._end; i++, j++) {
      _list[j] = src._list[i];
    }
  }

  /// Copies elements from one part of the slice to another part of itself
  /// The edge conditions can be changes with [sInc] and [eInc].
  /// [sInc] is whether the start is inclusive and [eInc] is whether the end is inclusive.
  void copyWithin(int start, int end, int dst, {bool sInc = true, bool enInc = false}) {
    if (!sInc) start += 1;
    if (enInc) end += 1;
    final length = len();
    if (start < 0 || start >= length || end < 0 || end > length || dst < 0 || dst >= length) {
      panic("Index out of bounds");
    }
    if (dst < start) {
      for (var i = start, j = dst; i < end; i++, j++) {
        _list[j + _start] = _list[i + _start];
      }
    } else {
      for (var i = end - 1, j = dst + end - start - 1; i >= start; i--, j--) {
        _list[j + _start] = _list[i + _start];
      }
    }
  }

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
    if (index < 0 || index >= len()) {
      return None;
    }
    return Some(getUnchecked(index));
  }

  /// Returns many indices at once.
  /// Returns an error if any index is out-of-bounds.
  Result<Arr<T>, GetManyError> getMany(Arr<int> indices) {
    final Arr<T?> array = Arr(null, indices.length);
    final length = len();
    for (final (int i, int index) in indices.iter().enumerate()) {
      if (index < 0 || index >= length) {
        return const Err(GetManyErrorRequestedIndexOutOfBounds());
      }
      array[i] = getUnchecked(index);
    }
    return Ok(array.cast<T>());
  }

// get_many_mut: Will not implement, covered by get_many

  /// Returns mutable references to many indices at once, without doing any checks.
  Arr<T> getManyUnchecked(Arr<int> indices) {
    if (indices.isEmpty()) {
      return Arr.constant(const []);
    }
    assert(isNotEmpty, "Requested indices, but this slice is empty.");
    var array = Arr(this.first, indices.length);
    for (final (int i, int index) in indices.iter().enumerate()) {
      assert(index >= 0 && index < length,
          "The requested index `$index` out of bounds. Length was `$length`");
      array[i] = getUnchecked(index);
    }
    return array;
  }
// get_many_unchecked_mut: Will not implement, covered by get_many_unchecked
// get_mut: Will not implement, mut the same as get
// get_unchecked_mut: Will not implement, mut the same as get_unchecked
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

  /// Return an array with the last N items in the slice. If the slice is not at least N in length, this will return None.
  Option<Arr<T>> lastChunk(int n) {
    if (n > len()) {
      return None;
    }
    return Some(Arr.generate(n, (index) => _list[_end - n + index]));
  }

// last_chunk_mut: Will not implement, covered by last_chunk
// last_mut: Will not implement, covered by last

  /// Returns the length of the slice.
  @pragma("vm:prefer-inline")
  int len() => _end - _start;

// make_ascii_lowercase: Will not implement, not possible in Dart
// make_ascii_uppercase: Will not implement, not possible in Dart
// partition_dedup: Implemented in extension

  /// Moves all consecutive repeated elements to the end of the slice according to [Comparable].
  /// Returns two slices. The first contains no consecutive repeated elements. The second contains all the duplicates in no specified order.
  /// The [sameBucket] function is passed the to two elements from the slice and must determine if the elements compare equal.
  /// The elements are passed in opposite order from their order in the slice, so if same_bucket(a, b) returns true, a is moved at the end of the slice.
  /// If the slice is sorted, the first returned slice contains no duplicates.
  (Slice<T> dedup, Slice<T> duplicates) partitionDedupBy(bool Function(T, T) sameBucket) {
    final length = len();
    if (length <= 1) {
      return (slice(0, length), slice(0, 0));
    }

    int nextRead = 1;
    int nextWrite = 1;

    while (nextRead < length) {
      if (!sameBucket(getUnchecked(nextRead), getUnchecked(nextWrite - 1))) {
        if (nextRead != nextWrite) {
          T temp = getUnchecked(nextRead);
          setUnchecked(nextRead, getUnchecked(nextWrite));
          setUnchecked(nextWrite, temp);
        }
        nextWrite += 1;
      }
      nextRead += 1;
    }

    return (slice(0, nextWrite), slice(nextWrite));
  }

  /// Moves all but the first of consecutive elements to the end of the list that resolve to the same key.
  /// Returns two slices. The first contains no consecutive repeated elements. The second contains all the duplicates in no specified order.
  /// If the list is sorted, the first returned list contains no duplicates.
  @pragma("vm:prefer-inline")
  (Slice<T> dedup, Slice<T> duplicates) partitionDedupByKey<K extends Comparable<K>>(
      K Function(T) key) {
    return partitionDedupBy((e0, e1) => key(e0) == key(e1));
  }

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
      if (predicate(getUnchecked(mid))) {
        low = mid + 1;
      } else {
        high = mid;
      }
    }

    return low;
  }

  /// Returns an iterator over [chunkSize] elements of the slice at a time, starting at the end of the slice.
  /// The chunks are slices and do not overlap. If chunk_size does not divide the length of the slice,
  /// then the last chunk will not have length [chunkSize].
  /// Panics if [chunkSize] is less than or equal to zero
  RIterator<Slice<T>> rchunks(int chunkSize) {
    return RIterator.fromIterable(_rchunksHelper(chunkSize));
  }

  @pragma("vm:prefer-inline")
  Iterable<Slice<T>> _rchunksHelper(int chunkSize) sync* {
    if (chunkSize <= 0) {
      panic("'chunkSize' must be positive");
    }
    final length = len();
    final numOfChunks = length ~/ chunkSize;
    for (var i = 0; i < numOfChunks; i++) {
      final end = length - (i * chunkSize);
      yield slice(end - chunkSize, end);
    }
    final remainderLength = length % chunkSize;
    if (remainderLength > 0) {
      yield slice(0, remainderLength);
    }
  }

// rchunks_exact: // todo, need to create an RIterator class that has `remainder()` method
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

  /// Rotates the slice in-place such that the first mid elements of the slice move to the end while the
  /// last `this.len() - mid` elements move to the front. After calling [rotateLeft], the element previously
  /// at index mid will become the first element in the slice.
  void rotateLeft(int mid) {
    int length = len();
    if (mid > length) {
      throw ArgumentError("mid is greater than the length of the list.");
    }
    if (mid == length || mid == 0) {
      return;
    }

    _reverse(this, 0, mid - 1);
    _reverse(this, mid, length - 1);
    _reverse(this, 0, length - 1);
  }

  /// Rotates the slice in-place such that the first `this.len() - k` elements of the slice move to the
  /// end while the last k elements move to the front. After calling rotate_right, the element
  /// previously at index `this.len() - k` will become the first element in the slice.
  void rotateRight(int k) {
    int length = len();
    if (k > length) {
      throw ArgumentError("mid is greater than the length of the list.");
    }
    if (k == length || k == 0) {
      return;
    }

    k = length - k; // Adjust mid for right rotation
    _reverse(this, 0, k - 1);
    _reverse(this, k, length - 1);
    _reverse(this, 0, length - 1);
  }

  void _reverse(Slice<T> list, int start, int end) {
    while (start < end) {
      T temp = list.getUnchecked(start);
      list.setUnchecked(start, list.getUnchecked(end));
      list.setUnchecked(end, temp);
      start++;
      end--;
    }
  }

  /// Returns an iterator over slices separated by elements that match pred,
  /// starting at the end of the slice and working backwards.
  /// The matched element is not contained in the slices.
  RIterator<Slice<T>> rsplit(bool Function(T) pred) {
    return RIterator(_rSplitHelper(pred).iterator);
  }

  Iterable<Slice<T>> _rSplitHelper(bool Function(T) pred) sync* {
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

  /// Returns an iterator over slices separated by elements that match pred, limited to returning at most n items, starting from the end.
  /// The matched element is not contained in the slices.
  /// The last element returned, if any, will contain the remainder of the slice.
  RIterator<Slice<T>> rsplitn(int n, bool Function(T) pred) {
    if (n < 0) {
      panic("'n' cannot be negative");
    }
    return RIterator(_rsplitnHelper(n, pred).iterator);
  }

  @pragma("vm:prefer-inline")
  Iterable<Slice<T>> _rsplitnHelper(int n, bool Function(T) pred) sync* {
    if (n == 0) {
      return;
    }
    var start = _end;
    var end = _end;
    var count = 1;
    while (start > _start && count < n) {
      if (pred(_list[start - 1])) {
        yield Slice(_list, start, end);
        end = start - 1;
        count++;
      }
      start--;
    }
    yield Slice(_list, _start, end);
  }

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
    if (n < 0) {
      panic("'n' cannot be negative");
    }
    return RIterator(_splitnHelper(n, pred).iterator);
  }

  @pragma("vm:prefer-inline")
  Iterable<Slice<T>> _splitnHelper(int n, bool Function(T) pred) sync* {
    if (n == 0) {
      return;
    }
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

// splitn_mut: Implemented by splitn

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

// swap_unchecked: Will not implement

  /// Swaps all elements in this with those in other.
  /// The length of other must be the same as this.
  /// Will [panic] if the length of other is not the same as this.
  void swapWithSlice(Slice<T> other) {
    final length = len();
    final otherLength = other.len();
    if (length != otherLength) {
      panic("Slices must be the same length, this is `$length` and other is `$otherLength");
    }
    for (var i = 0; i < length; i++) {
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

  /// Returns an iterator of slices of this slice over all contiguous windows of length size. The windows overlap.
  /// If the slice is shorter than size, the iterator returns no values.
  /// Panics if size is zero or less.
  RIterator<Slice<T>> windows(int size) {
    if (size <= 0) {
      panic("window size must be non-zero");
    }
    return RIterator.fromIterable(_windowsHelper(size));
  }

  Iterable<Slice<T>> _windowsHelper(int size) sync* {
    final numOfSlices = _end - _start - size + 1;
    for (int i = 0; i < numOfSlices; i++) {
      final start = _start + i;
      yield Slice(_list, start, start + size);
    }
  }

  T operator [](int index) {
    final n = _validateAndNormalize(index);
    return _list[n];
  }

  /// Returns the element at the given index without doing bounds checking.
  @pragma("vm:prefer-inline")
  T getUnchecked(int index) => _list[index + _start];

  @override
  void operator []=(int index, T value) {
    final n = _validateAndNormalize(index);
    _list[n] = value;
  }

  /// Sets the element at the given index without doing bounds checking.
  @pragma("vm:prefer-inline")
  void setUnchecked(int index, T value) => _list[index + _start] = value;

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

  // List<T> implementations
  //************************************************************************//

  @override
  List<T> operator +(List<T> other) {
    return this.toList() + other;
  }

  /// Adds [value] to the end of the slice, extending the length of the underlying list and this slice
  /// by one.
  /// {@template slice_underlying_manipulation_warning}
  /// Note, the ranges of other slices on the underlying list will not change, therefore use with care as this may shift the underlying data in other slices.
  /// {@endtemplate}
  @override
  void add(T value) {
    _list.insert(_end, value);
    _end++;
  }

  /// Appends all objects of [iterable] to the end of this slice.
  /// Extends the length of the underlying list and this slice by the number of objects in [iterable].
  /// The underlying list must be growable.
  /// {@macro slice_underlying_manipulation_warning}
  @override
  void addAll(Iterable<T> iterable) {
    final toAdd = iterable.toArr();
    final toAddLength = toAdd.length;
    if (toAddLength == 0) {
      return;
    }
    final listLength = _list.length;
    if (_end == listLength) {
      _list.addAll(toAdd);
    } else {
      final newList = List.generate(listLength + toAddLength, (i) {
        if (i < _end) {
          return _list[i];
        }
        if (i < _end + toAddLength) {
          return toAdd[i - _end];
        }
        return _list[i - toAddLength];
      });
      _list.clear();
      _list.addAll(newList);
    }
    _end += toAddLength;
  }

  @override
  Map<int, T> asMap() {
    return this.toList().asMap();
  }

  /// Returns a slice view where the elements are [U].
  @override
  Slice<U> cast<U>() => Slice(_list.cast<U>(), _start, _end);

  /// Clears the underlying data the slice encompasses. This slice's length after will be zero.
  /// {@macro slice_underlying_manipulation_warning}
  @override
  void clear() {
    _list.removeRange(_start, _end);
    _end = _start;
  }

  @override
  void fillRange(int start, int end, [T? fillValue]) {
    // Hoist the case to fail eagerly if the user provides an invalid `null`
    // value (or omits it) when T is a non-nullable type.
    T value = fillValue as T;
    final (normalizedStart, normalizedEnd) = _validateAndNormalizeRange(start, end);
    for (int i = normalizedStart; i < normalizedEnd; i++) {
      _list[i] = value;
    }
  }

  @override
  set first(T value) {
    if (_start == _end) {
      panic("Cannot set 'first' while slice is empty.");
    }
    _list[_start] = value;
  }

  @override
  Iterable<T> getRange(int start, int end) sync* {
    final startStart = _start;
    final startEnd = _end;
    final (normalizedStart, normalizedEnd) = _validateAndNormalizeRange(start, end);
    for (int i = normalizedStart; i < normalizedEnd; i++) {
      yield _list[i];
      if (_start != startStart || _end != startEnd) {
        throw ConcurrentModificationError("This slice was modified while yielding entries.");
      }
    }
  }

  @override
  int indexOf(T element, [int start = 0]) {
    for (final (index, e) in indexed.skip(start)) {
      if (e == element) {
        return index;
      }
    }
    return -1;
  }

  @override
  int indexWhere(bool Function(T element) test, [int start = 0]) {
    for (final (index, e) in indexed.skip(start)) {
      if (test(e)) {
        return index;
      }
    }
    return -1;
  }

  /// Inserts [element] at position [index] in this slice.
  /// This increases the length of the underlying list and this slice by one and shifts all objects at or after the index towards the end.
  /// The underlying list must be growable. The [index] value must be non-negative and no greater than [length].
  /// {@macro slice_underlying_manipulation_warning}
  @override
  void insert(int index, T element) {
    if (index > len()) {
      panic("'index' cannot be greater than the length of the slice.");
    }
    if (index < 0) {
      panic("'index' cannot be negative.");
    }
    _list.insert(_start + index, element);
    _end++;
  }

  /// Inserts all objects of [iterable] at position [index] in this slice.
  /// This increases the length of the slice by the length of [iterable] and shifts all later objects towards the end of the slice.
  /// The underlying list must be growable. The [index] value must be non-negative and no greater than [length].
  /// {@macro slice_underlying_manipulation_warning}
  @override
  void insertAll(int index, Iterable<T> iterable) {
    final toInsert = iterable.toList();
    _list.insertAll(_start + index, toInsert);
    _end += toInsert.length;
  }

  @override
  set last(T value) {
    if (_start == _end) {
      panic("Cannot set 'last' while slice is empty.");
    }
    _list[_end - 1] = value;
  }

  @override
  int lastIndexOf(T element, [int? start]) {
    for (final e in _list.getRange(_start, _end).indexed.skip(start ?? 0)) {
      if (e.$2 == element) {
        return e.$1;
      }
    }
    return -1;
  }

  @override
  int lastIndexWhere(bool Function(T element) test, [int? start]) {
    for (final e in _list.getRange(_start, _end).indexed.skip(start ?? 0)) {
      if (test(e.$2)) {
        return e.$1;
      }
    }
    return -1;
  }

  @override
  set length(int newLength) {
    panic("Cannot set the 'length' of a slice");
  }

  /// Removes the first occurrence of [value] from this slice.
  /// Returns true if [value] was in the slice, false otherwise. The slice must be growable.
  /// {@macro slice_underlying_manipulation_warning}
  @override
  bool remove(Object? value) {
    if (value is! T) {
      return false;
    }
    final index = indexOf(value);
    if (index == -1) {
      return false;
    }
    removeAt(index);
    return true;
  }

  /// Removes the object at position [index] from this slice.
  /// This method reduces the length of this slice and the underlying list by one and moves
  /// all later objects down by one position. Returns the removed value.
  /// The [index] must be in the range 0 ≤ index < length. The underlying list must be growable.
  /// {@macro slice_underlying_manipulation_warning}
  @override
  T removeAt(int index) {
    index = _validateAndNormalize(index);
    final element = _list.removeAt(index);
    _end--;
    return element;
  }

  /// Removes and returns the last object in this list. The list must be growable and non-empty.
  /// {@macro slice_underlying_manipulation_warning}
  @override
  T removeLast() {
    if (isEmpty) {
      panic("Cannot remove last element from an empty slice.");
    }
    final element = _list.removeAt(_end - 1);
    _end--;
    return element;
  }

  /// Removes a range of elements from the slice and the underlying list.
  /// Removes the elements with positions greater than or equal to [start] and less than [end],
  /// from the slice and underlying list. This reduces the slice and underlying list's length by end - start.
  /// The provided range, given by [start] and [end], must be valid. A range from [start] to [end]
  /// is valid if 0 ≤ start ≤ end ≤ [length]. An empty range (with end == start) is valid.
  /// The list must be growable.
  /// {@macro slice_underlying_manipulation_warning}
  @override
  void removeRange(int start, int end) {
    final (normalizedStart, normalizedEnd) = _validateAndNormalizeRange(start, end);
    _list.removeRange(normalizedStart, normalizedEnd);
    _end -= normalizedEnd - normalizedStart;
  }

  /// Removes all objects from this slice and the underlying list that satisfy [test].
  /// An object o satisfies [test] if test(o) is true. The slice's range shrinks by the number
  /// of elements removed.
  /// {@macro slice_underlying_manipulation_warning}
  @override
  void removeWhere(bool Function(T element) test) {
    int index = 0;
    int numRemoved = 0;
    _list.removeWhere((element) {
      if (index < _start || index >= _end) {
        index++;
        return false;
      }
      index++;
      if (test(element)) {
        numRemoved++;
        return true;
      }
      return false;
    });
    _end -= numRemoved;
  }

  /// Replaces a range of elements with the elements of [replacements].
  /// Removes the objects in the range from [start] to [end], then inserts the elements of [replacements] at [start].
  /// This will change the size of this slice by `replacements.length - (end - start)`.
  /// {@macro slice_underlying_manipulation_warning}
  @override
  void replaceRange(int start, int end, Iterable<T> replacements) {
    final (normalizedStart, normalizedEnd) = _validateAndNormalizeRange(start, end);
    final replacementsList = replacements.toList(growable: false);
    _list.replaceRange(normalizedStart, normalizedEnd, replacementsList);
    final replacementsLength = replacementsList.length;
    final diff = replacementsLength - (normalizedEnd - normalizedStart);
    _end += diff;
  }

  /// Removes all objects from this list that fail to satisfy [test].
  /// An object o satisfies [test] if test(o) is true. The slice's range shrinks by the number
  /// of elements removed.
  /// {@macro slice_underlying_manipulation_warning}
  @override
  void retainWhere(bool Function(T element) test) {
    int index = 0;
    int numRemoved = 0;
    _list.retainWhere((element) {
      if (index < _start || index >= _end) {
        index++;
        return true;
      }
      index++;
      if (!test(element)) {
        numRemoved++;
        return false;
      }
      return true;
    });
    _end -= numRemoved;
  }

  @override
  Iterable<T> get reversed => _list.getRange(_start, _end).toList(growable: false).reversed;

  /// Overwrites elements with the objects of [iterable].
  /// The elements of [iterable] are written into this list, starting at position [index].
  /// This operation does not increase the length of the slice or the underlying list.
  /// The [index] must be non-negative and no greater than [length].
  /// The [iterable] must not have more elements than what can fit from [index] to [length].
  /// If iterable is based on this slice, its values may change during the setAll
  @override
  void setAll(int index, Iterable<T> iterable) {
    final (normalizedStart, normalizedEnd) =
        _validateAndNormalizeRange(index, index + iterable.length);
    final iterator = iterable.iterator;
    for (int i = normalizedStart; i < normalizedEnd; i++) {
      if (!iterator.moveNext()) {
        return;
      }
      _list[i] = iterator.current;
    }
  }

  /// Writes some elements of [iterable] into a range of this list.
  /// Copies the objects of [iterable], skipping [skipCount] objects first, into the range from [start],
  /// inclusive, to [end], exclusive, of this slice.
  @override
  void setRange(int start, int end, Iterable<T> iterable, [int skipCount = 0]) {
    final (normalizedStart, normalizedEnd) = _validateAndNormalizeRange(start, end);
    final iterator = iterable.skip(skipCount).iterator;
    for (int i = normalizedStart; i < normalizedEnd; i++) {
      if (!iterator.moveNext()) {
        return;
      }
      _list[i] = iterator.current;
    }
  }

  @override
  void shuffle([Random? random]) {
    Random rand = random ?? Random();
    final sliceLength = len();
    for (int i = _start; i < _end; i++) {
      final temp = _list[i];
      final swapWith = _start + rand.nextInt(sliceLength);
      _list[i] = _list[swapWith];
      _list[swapWith] = temp;
    }
  }

  /// Sorts this slice according to the order specified by the [compare] function.
  @override
  void sort([int Function(T a, T b)? compare]) {
    sortUnstableBy(compare ?? (a, b) => Comparable.compare(a as Comparable, b as Comparable));
  }

  @override
  List<T> sublist(int start, [int? end]) {
    final (normalizedStart, normalizedEnd) = _validateAndNormalizeRange(start, end ?? len());
    return _list.sublist(normalizedStart, normalizedEnd);
  }

  //************************************************************************//

  (int normalizedStart, int normalizedEnd) _validateAndNormalizeRange(int start, int end) {
    if (start < 0 || end < 0) {
      panic("'start' and 'end' must be positive.");
    }
    final normalizedStart = start + _start;
    if (normalizedStart > _end) {
      panic("'start' is out of range.");
    }
    final normalizedEnd = end + _start;
    if (normalizedEnd > _end) {
      panic("'end' is out of range.");
    }
    return (normalizedStart, normalizedEnd);
  }

  int _validateAndNormalize(int index) {
    if (index < 0) {
      panic("'index' must be positive.");
    }
    final n = index + _start;
    if (n >= _end) {
      panic("'index' is out of slice boundary.");
    }
    return n;
  }
}
