part of 'iterator.dart';

class Cast<S, T> extends RIterator<T> {
  final Iterator<S> _source;

  Cast(this._source) : super._late() {
    _wIterator = this;
  }

  @override
  bool moveNext() => _source.moveNext();
  @override
  T get current => _source.current as T;
}
