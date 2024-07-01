part of 'slice.dart';

extension SliceOnListExtension<T> on List<T> {
  @pragma("vm:prefer-inline")
  Slice<T> asSlice() => Slice.fromList(this);

  @pragma("vm:prefer-inline")
  Slice<T> slice([int start = 0, int? end]) {
    end ??= length;
    return Slice(this, start, end);
  }
}

extension SliceOnSliceIntExtension<T extends num> on Slice<T> {
  /// Sorts the slice, but might not preserve the order of equal elements.
  @pragma("vm:prefer-inline")
  void sortUnstable() {
    _quickSort<num>(this, _start, _end - 1);
  }

  /// Checks if the elements of this slice are sorted. That is, for each element a and its following element b, a <= b must hold.
  bool isSorted() {
    for (int i = _start; i < _end - 1; i++) {
      if (_list[i].compareTo(_list[i + 1]) > 0) {
        return false;
      }
    }
    return true;
  }
}

extension SliceOnComparableSliceExtension<T extends Comparable<T>> on Slice<T> {
  /// Sorts the slice, but might not preserve the order of equal elements.
  @pragma("vm:prefer-inline")
  void sortUnstable() {
    _quickSort(this, _start, _end - 1);
  }

  /// Checks if the elements of this slice are sorted. That is, for each element a and its following element b, a <= b must hold.
  bool isSorted() {
    for (int i = _start; i < _end - 1; i++) {
      if (_list[i].compareTo(_list[i + 1]) > 0) {
        return false;
      }
    }
    return true;
  }

  /// Binary searches this slice for a given element. If the slice is not sorted, the returned result is unspecified and meaningless.
  ///
  /// If the value is found then [Ok] is returned, containing the index of the matching element.
  /// If there are multiple matches, then any one of the matches could be returned.
  /// The index is chosen deterministically, but is subject to change in future versions.
  /// If the value is not found then [Err] is returned, containing the index where a matching element could be inserted
  ///  while maintaining sorted order.
  Result<int, int> binarySearch(T x) {
    int left = 0;
    int right = length - 1;

    while (left <= right) {
      int mid = left + ((right - left) >> 1);
      if (this[mid] == x) {
        return Ok(mid);
      } else if (this[mid].compareTo(x) < 0) {
        left = mid + 1;
      } else {
        right = mid - 1;
      }
    }

    // If not found, return the index where it can be inserted to maintain sorted order.
    return Err(left);
  }

  /// Moves all consecutive repeated elements to the end of the slice according to [Comparable].
  /// Returns two slices. The first contains no consecutive repeated elements. The second contains all the duplicates in no specified order.
  /// If the slice is sorted, the first returned slice contains no duplicates.
  (Slice<T> dedup, Slice<T> duplicates) partitionDedup() {
    final length = len();
    if(length <= 1){
      return (slice(0, length), slice(0, 0));
    }
    final List<T> dedup = [];
    final List<T> duplicates = [];

    T lastOne = getUnchecked(0);
    dedup.add(lastOne);
    for (int i = 1; i < length; i++) {
      T current = getUnchecked(i);
      if (lastOne == current) {
        duplicates.add(current);
      } else {
        dedup.add(current);
      }
      lastOne = current;
    }
    for (int i = 0; i < dedup.length; i++) {
      setUnchecked(i, dedup[i]);
    }
    for (int i = dedup.length, j = 0; j < duplicates.length; i++, j++) {
      setUnchecked(i, duplicates[j]);
    }
    return (slice(0, dedup.length), slice(dedup.length, dedup.length + duplicates.length));
  }
}

//************************************************************************//

void _quickSort<T extends Comparable<T>>(Slice<T> slice, int low, int high) {
  if (low < high) {
    int pivotIndex = _partition(slice, low, high);
    _quickSort(slice, low, pivotIndex - 1);
    _quickSort(slice, pivotIndex + 1, high);
  }
}

int _partition<T extends Comparable<T>>(Slice<T> slice, int low, int high) {
  T pivot = slice._list[high];
  int i = low - 1;

  for (int j = low; j < high; j++) {
    if (slice._list[j].compareTo(pivot) < 0) {
      i++;
      _swap(slice._list, i, j);
    }
  }

  _swap(slice._list, i + 1, high);
  return i + 1;
}

void _swap<T extends Comparable<T>>(List<T> list, int i, int j) {
  T temp = list[i];
  list[i] = list[j];
  list[j] = temp;
}

//************************************************************************//

void _quickSortBy<T>(Slice<T> slice, int low, int high, int Function(T a, T b) compare) {
  if (low < high) {
    int pivotIndex = _partitionBy(slice, low, high, compare);
    _quickSortBy(slice, low, pivotIndex - 1, compare);
    _quickSortBy(slice, pivotIndex + 1, high, compare);
  }
}

int _partitionBy<T>(Slice<T> slice, int low, int high, int Function(T a, T b) compare) {
  T pivot = slice._list[high];
  int i = low - 1;

  for (int j = low; j < high; j++) {
    if (compare(slice._list[j], pivot) < 0) {
      i++;
      _swapBy(slice._list, i, j);
    }
  }

  _swapBy(slice._list, i + 1, high);
  return i + 1;
}

@pragma("vm:prefer-inline")
void _swapBy<T>(List<T> list, int i, int j) {
  T temp = list[i];
  list[i] = list[j];
  list[j] = temp;
}
