part of 'slice.dart';

extension SliceOnListExtension<T> on List<T> {
  Slice<T> asSlice() => Slice.fromList(this);

  Slice<T> slice([int start = 0, int? end]) {
    end ??= length;
    return Slice(this, start, end);
  }
}

extension SliceOnSliceIntExtension<T extends num> on Slice<T> {
  /// Sorts the slice, but might not preserve the order of equal elements.
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

void _quickSortBy<T>(
    Slice<T> slice, int low, int high, int Function(T a, T b) compare) {
  if (low < high) {
    int pivotIndex = _partitionBy(slice, low, high, compare);
    _quickSortBy(slice, low, pivotIndex - 1, compare);
    _quickSortBy(slice, pivotIndex + 1, high, compare);
  }
}

int _partitionBy<T>(
    Slice<T> slice, int low, int high, int Function(T a, T b) compare) {
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

void _swapBy<T>(List<T> list, int i, int j) {
  T temp = list[i];
  list[i] = list[j];
  list[j] = temp;
}
