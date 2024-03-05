
import 'package:rust_core/result.dart';
import 'package:rust_core/slice.dart';

/// A fixed-size array, denoted as [T; N] in Rust.
extension type Arr<T>._(List<T> list) implements Iterable<T> {
  
  Arr(T defaultVal, int size) : list = List.filled(size, defaultVal, growable: false);

  const Arr.constant(this.list);

  Arr.fromList(this.list);

  Arr.empty() : list = const [];
  
  T operator [](int index) => list[index];
  void operator []=(int index, T value) => list[index] = value;

  int get length => list.length;

  Arr<U> cast<U>() => Arr._(list.cast<U>());

  // as_ascii: Will not be implemented, not possible in Dart
  // as_ascii_unchecked_mut: Will not be implemented, not possible in Dart
  // as_mut_slice: Will not be implemented, covered by `asSlice`
  
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
    return (Slice(list, 0, list.length - index), Slice(list, list.length - index, list.length));
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
  Result<Arr<S>,F> tryMap<S,F extends Object>(Result<S,F> Function(T) f) {
    List<S?> result = List.filled(list.length, null, growable: false);
    for (int i = 0; i < list.length; i++) {
      var res = f(list[i]);
      if (res case Err()){
        return res.into();
      }
      result[i] = res.unwrap();
    }
    return Ok(Arr._(result.cast<S>()));
  }
}