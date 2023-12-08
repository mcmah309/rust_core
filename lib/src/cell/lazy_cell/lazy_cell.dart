import 'package:rust_core/cell.dart';

/// A value which is initialized on the first access.
///
/// Equality: Cells are equal if they are the same base type and have the same evaluated value or are unevaluated.
///
/// Hash: Cells hash to their evaluated value or hash the same if unevaluated.
abstract interface class LazyCell<T extends Object>
    implements NullableLazyCell<T> {
  factory LazyCell(T Function() func) = NonNullableLazyCell;

  const factory LazyCell.constant(T Function() func, Object id) = ConstNonNullableLazyCell;
}