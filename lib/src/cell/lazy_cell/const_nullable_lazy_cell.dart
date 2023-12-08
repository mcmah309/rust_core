import 'package:rust_core/cell.dart';

/// A value which is initialized on the first access. Nullable implementation of [LazyCell]
///
/// Equality: Cells are equal if they are [ConstNullableLazyCell] and have the same evaluated value or are unevaluated.
///
/// Hash: Cells hash to their evaluated value or hash the same if unevaluated.
class ConstNullableLazyCell<T> implements NullableLazyCell<T> {
  static final _cache = Expando();
  final T Function() _func;

  /// Const objects all share the same canonicalization, meaning instantiation of the same class with the same arguments
  /// will be the same instance. Therefore, if you need multiple const versions, an [id] is needed.
  final Object id;

  const ConstNullableLazyCell(this._func, this.id);

  @override
  T call() {
    (T,)? cacheResult = _cache[this] as (T,)?;
    if (cacheResult != null) return cacheResult.$1;
    T funcResult = _func();
    _cache[this] = (funcResult,);
    return funcResult;
  }

  @override
  int get hashCode {
    var valueHash = _cache[this]?.hashCode ?? 0;
    return valueHash;
  }

  @override
  bool operator ==(Object other) {
    return other is ConstNullableLazyCell &&
        _cache[this] == _cache[other];
  }

  @override
  String toString() {
    (T,)? cacheResult = _cache[this] as (T,)?;
    String initializedState;
    if (cacheResult == null) {
      initializedState = "Uninitialized ";
    } else {
      initializedState = "Initialized ";
    }
    return initializedState + runtimeType.toString();
  }
}