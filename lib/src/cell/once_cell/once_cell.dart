import 'package:rust_core/cell.dart';
import 'package:rust_core/option.dart';
import 'package:rust_core/result.dart';

/// OnceCell, A cell which can be written to only once.
///
/// Equality: Cells are equal if they have the same value or are not set.
///
/// Hash: Cells hash to their existing or the same if not set.
abstract interface class OnceCell<T extends Object>
    implements NullableOnceCell<T> {
  factory OnceCell() = NonNullableOnceCell;

  const factory OnceCell.constant(Object id) = ConstNonNullableOnceCell;

  factory OnceCell.withValue(T val) = NonNullableOnceCell.withValue;

  /// Gets the reference to the underlying value.
  Option<T> get();

  /// Sets the contents of the cell to value.
  Result<(), T> set(T value);

  /// Takes the value out of this OnceCell, moving it back to an uninitialized state.
  Option<T> take();
}
