part of 'iterator.dart';

class MapRIterator<S, T> extends RIterator<T> {
  T? _current;
  final Iterator<S> _iterator;
  final T Function(S) _f;

  MapRIterator(this._iterator, this._f) : super._late() {
    _wIterator = this;
  }

  @override
  bool moveNext() {
    if (_iterator.moveNext()) {
      _current = _f(_iterator.current);
      return true;
    }
    _current = null;
    return false;
  }

  @override
  T get current => _current as T;
  
  // @override
  // RIterator clone() {
  //   // TODO: implement clone
  //   throw UnimplementedError();
  // }
}
