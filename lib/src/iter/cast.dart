part of 'iterator.dart';

class Cast<S, T> extends Iter<T> {
  Iterator<S> _source;

  Cast(this._source) : super._late() {
    _wIterator = this;
  }

  @override
  bool moveNext() => _source.moveNext();
  @override
  T get current => _source.current as T;

  @override
  Cast<S, T> clone() {
    final temp = Clone._trackable(_source);
    _source = temp;
    return Cast(Clone._clone(temp).iterator);
  }
}
