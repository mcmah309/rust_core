import 'package:rust_core/array.dart';
import 'package:rust_core/iter.dart';
import 'package:rust_core/option.dart';
import 'package:rust_core/result.dart';

/// An iterator over the range [start..end), where start >= end or start <= end.
@pragma("vm:prefer-inline")
RIterator<int> range(int start, int end) {
  return RIterator.fromIterable(_range(start, end));
}

/// An array of [int] in the range [start..end), where start >= end or start <= end. [step] must be positive.
@pragma("vm:prefer-inline")
Arr<int> rangeArr(int start, int end, {int step = 1}) {
  assert(step > 0, "step must be positive");
  if (start < end) {
    int length = ((end - start) + step - 1) ~/ step;
    return Arr<int>.generate(length, (index) => start + (index * step));
  } else {
    int length = ((start - end) + step - 1) ~/ step;
    return Arr<int>.generate(length, (index) => start - (index * step));
  }
}

typedef Range = (int, int);

extension Range2Extension on Range {
  /// An iterator over the range [$1..$2), where $1 >= $2 or $1 <= $2.
  @pragma("vm:prefer-inline")
  RIterator<int> range() {
    return RIterator.fromIterable(_range($1, $2));
  }

  //************************************************************************//

  @pragma("vm:prefer-inline")
  Result<(), int> advanceBy(int n) {
    return RIterator.fromIterable(_range($1, $2)).advanceBy(n);
  }

  @pragma("vm:prefer-inline")
  bool all(bool Function(int) f) {
    return RIterator.fromIterable(_range($1, $2)).all(f);
  }

  @pragma("vm:prefer-inline")
  ArrayChunks<int> arrayChunks(int size) {
    return RIterator.fromIterable(_range($1, $2)).arrayChunks(size);
  }

  @pragma("vm:prefer-inline")
  Chain<int> chain(Iterator<int> other) {
    return RIterator.fromIterable(_range($1, $2)).chain(other);
  }

  @pragma("vm:prefer-inline")
  RIterator<int> clone() {
    return RIterator.fromIterable(_range($1, $2)).clone();
  }

  @pragma("vm:prefer-inline")
  int cmpBy<U>(Iterator<U> other, int Function(int, U) f) {
    return RIterator.fromIterable(_range($1, $2)).cmpBy(other, f);
  }

  @pragma("vm:prefer-inline")
  List<int> collectList({bool growable = true}) {
    return RIterator.fromIterable(_range($1, $2))
        .collectList(growable: growable);
  }

  @pragma("vm:prefer-inline")
  Set<int> collectSet() {
    return RIterator.fromIterable(_range($1, $2)).collectSet();
  }

  @pragma("vm:prefer-inline")
  int count() {
    return RIterator.fromIterable(_range($1, $2)).count();
  }

  @pragma("vm:prefer-inline")
  Cycle<int> cycle() {
    return RIterator.fromIterable(_range($1, $2)).cycle();
  }

  @pragma("vm:prefer-inline")
  RIterator<(int, int)> enumerate() {
    return RIterator.fromIterable(_range($1, $2)).enumerate();
  }

  @pragma("vm:prefer-inline")
  bool eq<U>(Iterator<U> other) {
    return RIterator.fromIterable(_range($1, $2)).eq(other);
  }

  @pragma("vm:prefer-inline")
  bool eqBy<U>(Iterator<U> other, bool Function(int, U) f) {
    return RIterator.fromIterable(_range($1, $2)).eqBy(other, f);
  }

  @pragma("vm:prefer-inline")
  RIterator<int> filter(bool Function(int) f) {
    return RIterator.fromIterable(_range($1, $2)).filter(f);
  }

  @pragma("vm:prefer-inline")
  RIterator<U> filterMap<U extends Object>(Option<U> Function(int) f) {
    return RIterator.fromIterable(_range($1, $2)).filterMap(f);
  }

  @pragma("vm:prefer-inline")
  Option<int> find(bool Function(int) f) {
    return RIterator.fromIterable(_range($1, $2)).find(f);
  }

  @pragma("vm:prefer-inline")
  Option<U> findMap<U extends Object>(Option<U> Function(int) f) {
    return RIterator.fromIterable(_range($1, $2)).findMap(f);
  }

  @pragma("vm:prefer-inline")
  FlatMap<int, U> flatMap<U>(Iterator<U> Function(int) f) {
    return RIterator.fromIterable(_range($1, $2)).flatMap(f);
  }

  @pragma("vm:prefer-inline")
  RIterator<int> inspect(void Function(int) f) {
    return RIterator.fromIterable(_range($1, $2)).inspect(f);
  }

  @pragma("vm:prefer-inline")
  RIterator<int> intersperse(int element) {
    return RIterator.fromIterable(_range($1, $2)).intersperse(element);
  }

  @pragma("vm:prefer-inline")
  RIterator<int> intersperseWith(int Function() f) {
    return RIterator.fromIterable(_range($1, $2)).intersperseWith(f);
  }

  @pragma("vm:prefer-inline")
  bool isPartitioned(bool Function(int) f) {
    return RIterator.fromIterable(_range($1, $2)).isPartitioned(f);
  }

  @pragma("vm:prefer-inline")
  bool isSortedBy(int Function(int, int) f) {
    return RIterator.fromIterable(_range($1, $2)).isSortedBy(f);
  }

  @pragma("vm:prefer-inline")
  bool isSortedByKey<U extends Comparable<U>>(U Function(int) f) {
    return RIterator.fromIterable(_range($1, $2)).isSortedByKey(f);
  }

  @pragma("vm:prefer-inline")
  Option<int> lastOrOption() {
    return RIterator.fromIterable(_range($1, $2)).lastOrOption();
  }

  @pragma("vm:prefer-inline")
  RIterator<U> mapWhile<U extends Object>(Option<U> Function(int) f) {
    return RIterator.fromIterable(_range($1, $2)).mapWhile(f);
  }

  @pragma("vm:prefer-inline")
  RIterator<U> mapWindows<U>(int size, U Function(Arr<int>) f) {
    return RIterator.fromIterable(_range($1, $2)).mapWindows(size, f);
  }

  @pragma("vm:prefer-inline")
  Option<int> maxBy(int Function(int, int) f) {
    return RIterator.fromIterable(_range($1, $2)).maxBy(f);
  }

  @pragma("vm:prefer-inline")
  Option<int> maxByKey<U extends Comparable<U>>(U Function(int) f) {
    return RIterator.fromIterable(_range($1, $2)).maxByKey(f);
  }

  @pragma("vm:prefer-inline")
  Option<int> minBy(int Function(int, int) f) {
    return RIterator.fromIterable(_range($1, $2)).minBy(f);
  }

  @pragma("vm:prefer-inline")
  Option<int> minByKey<U extends Comparable<U>>(U Function(int) f) {
    return RIterator.fromIterable(_range($1, $2)).minByKey(f);
  }

  @pragma("vm:prefer-inline")
  Result<Arr<int>, RIterator<int>> nextChunk(int size) {
    return RIterator.fromIterable(_range($1, $2)).nextChunk(size);
  }

  @pragma("vm:prefer-inline")
  Option<int> nth(int n) {
    return RIterator.fromIterable(_range($1, $2)).nth(n);
  }

  @pragma("vm:prefer-inline")
  (List<int>, List<int>) partition(bool Function(int) f) {
    return RIterator.fromIterable(_range($1, $2)).partition(f);
  }

  @pragma("vm:prefer-inline")
  int partitionInPlace(bool Function(int) f) {
    return RIterator.fromIterable(_range($1, $2)).partitionInPlace(f);
  }

  @pragma("vm:prefer-inline")
  Peekable<int> peekable() {
    return RIterator.fromIterable(_range($1, $2)).peekable();
  }

  @pragma("vm:prefer-inline")
  Option<int> position(bool Function(int) f) {
    return RIterator.fromIterable(_range($1, $2)).position(f);
  }

  @pragma("vm:prefer-inline")
  RIterator<int> rev() {
    return RIterator.fromIterable(_range($1, $2)).rev();
  }

  @pragma("vm:prefer-inline")
  Option<int> rposition(bool Function(int) f) {
    return RIterator.fromIterable(_range($1, $2)).rposition(f);
  }

  @pragma("vm:prefer-inline")
  RIterator<U> scan<U extends Object>(U initial, Option<U> Function(U, int) f) {
    return RIterator.fromIterable(_range($1, $2)).scan(initial, f);
  }

  @pragma("vm:prefer-inline")
  RIterator<int> stepBy(int step) {
    return RIterator.fromIterable(_range($1, $2)).stepBy(step);
  }

  @pragma("vm:prefer-inline")
  Zip<int, U> zip<U>(Iterator<U> other) {
    return RIterator.fromIterable(_range($1, $2)).zip(other);
  }
}

@pragma("vm:prefer-inline")
Iterable<int> _range(int start, int end) sync* {
  final step = start < end ? 1 : -1;
  if (start < end) {
    do {
      yield start;
      start += step;
    } while (start < end);
  } else {
    while (end < start) {
      yield start;
      start += step;
    }
  }
}
