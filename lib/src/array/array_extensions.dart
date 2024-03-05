import 'package:rust_core/array.dart';

extension ArrayOnListExtension<T> on List<T> {
  /// Transmutes a List into an Array
  Array<T> asArr() => Array.fromList(this);
}
extension ArrayOnIterableExtension<T> on Iterable<T> {
  /// Creates an Array from a List
  Array<T> toArr() => Array.fromList(toList(growable: false));
}