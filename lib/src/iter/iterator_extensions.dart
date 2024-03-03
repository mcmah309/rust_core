
part of 'iterator.dart';

extension IterableExtension<T> on Iterable<T> {
  RIterator<T> iter() => RIterator<T>(this);
}


extension IteratorSliceExtension<T> on RIterator<Slice<T>> {

  //todo

}

extension IteratorIterableExtension<T> on RIterator<Iterable<T>> {

  //todo

}

extension IteratorOptionExtension<T> on RIterator<Option<T>> {

  //todo

}

extension IteratorResultExtension<T, E extends Object> on RIterator<Result<T, E>> {

  //todo

}
