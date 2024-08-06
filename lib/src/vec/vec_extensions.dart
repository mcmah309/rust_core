import 'vec.dart';

extension VecOnIterableExtension<T> on Iterable<T> {
  @pragma('vm:prefer-inline')
  Vec<T> toVec() => toList(growable: true);
}

extension VecOnIteratorExtension<T> on Iterator<T> {
  @pragma('vm:prefer-inline')
  Vec<T> collectVec() {
    final list = <T>[];
    while (moveNext()) {
      list.add(current);
    }
    return list;
  }
}

extension VecOnListListExtension<T> on List<List<T>> {
  @pragma('vm:prefer-inline')
  Vec<T> flatten() {
    return expand((element) => element).toList();
  }
}
