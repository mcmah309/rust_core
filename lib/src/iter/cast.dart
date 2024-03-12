part of 'iterator.dart';

class CastRIterator<S, T> extends RIterator<T> {
  final Iterator<S> _source;

  CastRIterator(this._source) : super._late() {
    _wIterator = this;
  }

  @override
  bool moveNext() => _source.moveNext();
  @override
  T get current => _source.current as T;
}
