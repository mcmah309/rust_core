import 'package:rust_core/slice.dart';

extension SliceOnListExtension<T> on List<T> {
  Slice<T> asSlice() => Slice.fromList(this);
}

extension SliceOnSliceIntExtension<T> on Slice<int> {
  /// Sorts the slice, but might not preserve the order of equal elements.
  void sortUnstable() {
    _quickSort<num>(this, start, end - 1);
  }

  /// Sorts the slice with a comparator function, but might not preserve the order of equal elements.
  void sortUnstableBy(int Function(num a, num b) compare) {
    _quickSortBy<num>(this, start, end - 1, compare);
  }

  /// Sorts the slice with a key extraction function, but might not preserve the order of equal elements.
  void sortUnstableByKey<K extends Comparable<K>>(K Function(num a) key) {
    _quickSortBy(this, start, end - 1, (a, b) => key(a).compareTo(key(b)));
  }
}

extension SliceOnSliceDoubleExtension<T> on Slice<double> {
  /// Sorts the slice, but might not preserve the order of equal elements.
  void sortUnstable() {
    _quickSort<num>(this, start, end - 1);
  }

  /// Sorts the slice with a comparator function, but might not preserve the order of equal elements.
  void sortUnstableBy(int Function(num a, num b) compare) {
    _quickSortBy<num>(this, start, end - 1, compare);
  }

  /// Sorts the slice with a key extraction function, but might not preserve the order of equal elements.
  void sortUnstableByKey<K extends Comparable<K>>(K Function(num a) key) {
    _quickSortBy(this, start, end - 1, (a, b) => key(a).compareTo(key(b)));
  }
}

extension SliceOnComparableSliceExtension<T extends Comparable<T>> on Slice<T> {
  /// Sorts the slice, but might not preserve the order of equal elements.
  void sortUnstable() {
    _quickSort(this, start, end - 1);
  }

  /// Sorts the slice with a comparator function, but might not preserve the order of equal elements.
  void sortUnstableBy(int Function(T a, T b) compare) {
    _quickSortBy(this, start, end - 1, compare);
  }

  /// Sorts the slice with a key extraction function, but might not preserve the order of equal elements.
  void sortUnstableByKey<K extends Comparable<K>>(K Function(T a) key) {
    _quickSortBy(this, start, end - 1, (a, b) => key(a).compareTo(key(b)));
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
    T pivot = slice.list[high];
    int i = low - 1;

    for (int j = low; j < high; j++) {
      if (slice.list[j].compareTo(pivot) < 0) {
        i++;
        _swap(slice.list, i, j);
      }
    }

    _swap(slice.list, i + 1, high);
    return i + 1;
  }

  void _swap<T extends Comparable<T>>(List<T> list, int i, int j) {
    T temp = list[i];
    list[i] = list[j];
    list[j] = temp;
  }

  //************************************************************************//

  void quickSortBy<T>(Slice<T> slice, int Function(T a, T b) compare) {
  _quickSortBy(slice, 0, slice.end - 1, compare);
}

void _quickSortBy<T>(Slice<T> slice, int low, int high, int Function(T a, T b) compare) {
  if (low < high) {
    int pivotIndex = _partitionBy(slice, low, high, compare);
    _quickSortBy(slice, low, pivotIndex - 1, compare);
    _quickSortBy(slice, pivotIndex + 1, high, compare);
  }
}

int _partitionBy<T>(Slice<T> slice, int low, int high, int Function(T a, T b) compare) {
  T pivot = slice.list[high];
  int i = low - 1;

  for (int j = low; j < high; j++) {
    if (compare(slice.list[j], pivot) < 0) {
      i++;
      _swapBy(slice.list, i, j);
    }
  }

  _swapBy(slice.list, i + 1, high);
  return i + 1;
}

void _swapBy<T>(List<T> list, int i, int j) {
  T temp = list[i];
  list[i] = list[j];
  list[j] = temp;
}
