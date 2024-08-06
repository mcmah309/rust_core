import 'package:rust_core/cell.dart';

/// A value which is asynchronously initialized on the first access.
///
/// Equality: Cells are equal if they have the same evaluated value or are unevaluated.
///
/// Hash: Cells hash to their evaluated value or hash the same if unevaluated.
abstract interface class LazyCellAsync<T extends Object>
    implements NullableLazyCellAsync<T> {
  factory LazyCellAsync(Future<T> Function() func) = NonNullableLazyCellAsync;
}
