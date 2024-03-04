
import 'package:rust_core/result.dart';
import 'package:rust_core/slice.dart';

extension type Array<T>._(List<T> list) {
  
  Array(T defaultVal, int size) : list = List.filled(size, defaultVal, growable: false);
  
  T operator [](int index) => list[index];
  void operator []=(int index, T value) => list[index] = value;

  // as_ascii: Will not be implemented, not possible in Dart
  // as_ascii_unchecked_mut: Will not be implemented, not possible in Dart
  // as_mut_slice: Will not be implemented, covered by `asSlice`
  
  Slice<T> asSlice() => Slice.fromList(list);

  // each_mut: Will not be implemented, not possible in Dart
  // each_ref: Will not be implemented, not possible in Dart
  
  /// Returns an array of the same size as self, with function f applied to each element in order.
  Array<U> map<U>(U Function(T) f) {
    return Array._(list.map(f).toList(growable: false));
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
  Result<Array<S>,F> tryMap<S,F extends Object>(Result<S,F> Function(T) f) {
    List<S?> result = List.filled(list.length, null, growable: false);
    for (int i = 0; i < list.length; i++) {
      var res = f(list[i]);
      if (res case Err()){
        return res.into();
      }
      result[i] = res.unwrap();
    }
    return Ok(Array._(result.cast<S>()));
  }
}