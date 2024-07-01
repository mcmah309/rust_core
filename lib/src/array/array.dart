import 'package:rust_core/result.dart';
import 'package:rust_core/slice.dart';
import 'package:rust_core/option.dart';
import 'package:rust_core/iter.dart';

/// A fixed-size array, denoted as [T; N] in Rust.
extension type Arr<T>._(List<T> list) implements Iterable<T> {
  Arr(T defaultVal, int size)
      : list = List.filled(size, defaultVal, growable: false);

  const Arr.constant(this.list);

  Arr.fromList(this.list);

  Arr.empty() : list = const [];

  T operator [](int index) => list[index];
  void operator []=(int index, T value) => list[index] = value;

  // as_ascii: Will not be implemented, not possible in Dart
  // as_ascii_unchecked_mut: Will not be implemented, not possible in Dart
  // as_mut_slice: Will not be implemented, covered by `asSlice`

  @pragma("vm:prefer-inline")
  Slice<T> asSlice() => Slice.fromList(list);

  // each_mut: Will not be implemented, not possible in Dart
  // each_ref: Will not be implemented, not possible in Dart

  /// Returns an array of the same size as self, with function f applied to each element in order.
  Arr<U> map<U>(U Function(T) f) {
    return Arr._(list.map(f).toList(growable: false));
  }

  /// Divides array into two [Slice]s at index from end.
  /// The first will contain all indices from [0, N - M) (excluding the index N - M itself) and
  /// the second will contain all indices from [N - M, N) (excluding the index N itself).
  (Slice<T>, Slice<T>) rsplitSlice(int index) {
    assert(index >= 0 && index <= list.length, "Index out of bounds");
    return (
      Slice(list, 0, list.length - index),
      Slice(list, list.length - index, list.length)
    );
  }

  // rsplit_array_mut: Will not be implemented, not possible in Dart
  // rsplit_array_ref: Will not be implemented, not possible in Dart

  /// Divides array into two [Slice]s at index from start.
  /// The first will contain all indices from [0, M) (excluding the index M itself) and
  /// the second will contain all indices from [M, N) (excluding the index N itself).
  (Slice<T>, Slice<T>) splitSlice(int index) {
    assert(index >= 0 && index <= list.length, "Index out of bounds");
    return (Slice(list, 0, index), Slice(list, index, list.length));
  }

  // split_array_mut: Will not be implemented, not possible in Dart
  // split_array_ref: Will not be implemented, not possible in Dart
  // transpose: Will not be implemented, not possible in Dart

  /// A fallible function f applied to each element on this array in order to return an array the same size as this or the first error encountered.
  Result<Arr<S>, F> tryMap<S, F extends Object>(Result<S, F> Function(T) f) {
    List<S?> result = List.filled(list.length, null, growable: false);
    for (int i = 0; i < list.length; i++) {
      var res = f(list[i]);
      if (res case Err()) {
        return res.into();
      }
      result[i] = res.unwrap();
    }
    return Ok(Arr._(result.cast<S>()));
  }

  // Iterable: Overriding iterable methods
  //************************************************************************//

  /// Returns the first element of an iterator, None if empty.
  Option<T> first() {
    final first = list.firstOrNull;
    if (first == null) {
      return None;
    }
    return Some(first);
  }

  /// Returns true if the iterator is empty, false otherwise.
  @pragma("vm:prefer-inline")
  bool isEmpty() => list.isEmpty;

  /// Returns true if the iterator is not empty, false otherwise.
  @pragma("vm:prefer-inline")
  bool isNotEmpty() => list.isNotEmpty;

  @pragma("vm:prefer-inline")
  Iterator<T> get iterator => list.iterator;

  /// Returns the last element of an iterator, None if empty.
  Option<T> last() {
    final last = list.lastOrNull;
    if (last == null) {
      return None;
    }
    return Some(last);
  }

  /// Returns the length of an iterator.
  @pragma("vm:prefer-inline")
  int length() => list.length;

  /// Returns the single element of an iterator, None if this is empty or has more than one element.
  Option<T> single() {
    final firstTwo = list.take(2).iterator;
    if (!firstTwo.moveNext()) {
      return None;
    }
    final first = firstTwo.current;
    if (!firstTwo.moveNext()) {
      return Some(first);
    }
    return None;
  }

  // bool any(bool Function(T) f) {
  //   return list.any(f);
  // }

  /// Casts this Arr<T> to an Arr<U>.
  @pragma("vm:prefer-inline")
  Arr<U> cast<U>() => Arr.fromList(list.cast<U>());

  // bool contains(Object? element) => list.contains(element);

  // T elementAt(int index) => list.elementAt(index);

  // bool every(bool Function(T) f) => list.every(f);

  @pragma("vm:prefer-inline")
  RIterator<U> expand<U>(Iterable<U> Function(T) f) =>
      RIterator(list.expand(f).iterator);

  // T firstWhere(bool Function(T) f, {T Function()? orElse}) => list.firstWhere(f, orElse: orElse);

  // U fold<U>(U initialValue, U Function(U previousValue, T element) f) => list.fold(initialValue, f);

  @pragma("vm:prefer-inline")
  RIterator<T> followedBy(Iterable<T> other) =>
      RIterator(list.followedBy(other).iterator);

  // void forEach(void Function(T) f) => list.forEach(f);

  // String join([String separator = '']) => list.join(separator);

  // T lastWhere(bool Function(T) f, {T Function()? orElse}) => list.lastWhere(f, orElse: orElse);

  // RIterator<U> map<U>(U Function(T) f) => list.map(f));

  // T reduce(T Function(T, T) f) => list.reduce(f);

  // T singleWhere(bool Function(T) f, {T Function()? orElse}) => list.singleWhere(f, orElse: orElse);

  @pragma("vm:prefer-inline")
  RIterator<T> skip(int count) => RIterator(list.skip(count).iterator);

  @pragma("vm:prefer-inline")
  RIterator<T> skipWhile(bool Function(T) f) =>
      RIterator(list.skipWhile(f).iterator);

  @pragma("vm:prefer-inline")
  RIterator<T> take(int count) => RIterator(list.take(count).iterator);

  @pragma("vm:prefer-inline")
  RIterator<T> takeWhile(bool Function(T) f) =>
      RIterator(list.takeWhile(f).iterator);

  // List<T> toList({bool growable = true}) => list.toList(growable: growable);

  // Set<T> toSet() => list.toSet();

  // String toString() => list.toString();

  @pragma("vm:prefer-inline")
  RIterator<T> where(bool Function(T) f) => RIterator(list.where(f).iterator);

  @pragma("vm:prefer-inline")
  RIterator<U> whereType<U>() => RIterator(list.whereType<U>().iterator);

  //************************************************************************//

  operator +(Arr<T> other) => Arr._(list + other.list);
}
