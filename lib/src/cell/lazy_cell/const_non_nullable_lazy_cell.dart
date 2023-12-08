import 'package:rust_core/cell.dart';

/// A value which is initialized on the first access. Const Non-nullable implementation of [LazyCell].
///
/// Equality: Cells are equal if they are [ConstNonNullableLazyCell] and have the same evaluated value or are
/// unevaluated.
///
/// Hash: Cells hash to their evaluated value or hash the same if unevaluated.
class ConstNonNullableLazyCell<T extends Object> implements LazyCell<T> {
  static final _cache = Expando();
  final T Function() _func;

  /// Const objects all share the same canonicalization, meaning instantiation of the same class with the same arguments
  /// will be the same instance. Therefore, if you need multiple const versions, an [id] is needed.
  final Object id;

  const ConstNonNullableLazyCell(this._func, this.id);

  @override
  T call() {
    T? result = _cache[this] as T?;
    if (result != null) return result;
    result = _func();
    _cache[this] = result;
    return result;
  }

  @override
  int get hashCode {
    var valueHash = _cache[this]?.hashCode ?? 0;
    return valueHash;
  }

  @override
  bool operator ==(Object other) {
    return other is ConstNonNullableLazyCell &&
        _cache[this] == _cache[other];
  }

  @override
  String toString() {
    T? cacheResult = _cache[this] as T?;
    String initializedState;
    if (cacheResult == null) {
      initializedState = "Uninitialized ";
    } else {
      initializedState = "Initialized ";
    }
    return initializedState + runtimeType.toString();
  }
}