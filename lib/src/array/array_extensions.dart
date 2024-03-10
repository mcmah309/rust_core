import 'package:rust_core/array.dart';

extension ArrayOnListExtension<T> on List<T> {
  /// Transmutes a List into an Array
  Arr<T> asArr() => Arr.fromList(this);
}

extension ArrayOnIterableExtension<T> on Iterable<T> {
  /// Creates an Array from an Iterable
  Arr<T> toArr() => Arr.fromList(toList(growable: false));
}
