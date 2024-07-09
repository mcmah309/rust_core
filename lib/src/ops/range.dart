import 'package:rust_core/array.dart';
import 'package:rust_core/iter.dart';
import 'package:rust_core/option.dart';
import 'package:rust_core/panic.dart';
import 'package:rust_core/result.dart';

/// An iterator over the range [start..end), where start >= end or start <= end.
@pragma("vm:prefer-inline")
RIterator<int> range(int start, int end, [int? step]) {
  return RIterator.fromIterable(_rangeWithStep(start, end, step));
}

extension Range2Extension on (int, int) {
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
    return RIterator.fromIterable(_range($1, $2)).collectList(growable: growable);
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

extension Range3Extension on (int, int, int) {
  /// An iterator over the range [$1..$2), where $1 >= $2 or $1 <= $2, stepping by $3.
  @pragma("vm:prefer-inline")
  RIterator<int> range() {
    return RIterator.fromIterable(_rangeWithStep($1, $2, $3));
  }

  //************************************************************************//

  @pragma("vm:prefer-inline")
  Result<(), int> advanceBy(int n) {
    return RIterator.fromIterable(_rangeWithStep($1, $2, $3)).advanceBy(n);
  }

  @pragma("vm:prefer-inline")
  bool all(bool Function(int) f) {
    return RIterator.fromIterable(_rangeWithStep($1, $2, $3)).all(f);
  }

  @pragma("vm:prefer-inline")
  ArrayChunks<int> arrayChunks(int size) {
    return RIterator.fromIterable(_rangeWithStep($1, $2, $3)).arrayChunks(size);
  }

  @pragma("vm:prefer-inline")
  Chain<int> chain(Iterator<int> other) {
    return RIterator.fromIterable(_rangeWithStep($1, $2, $3)).chain(other);
  }

  @pragma("vm:prefer-inline")
  RIterator<int> clone() {
    return RIterator.fromIterable(_rangeWithStep($1, $2, $3)).clone();
  }

  @pragma("vm:prefer-inline")
  int cmpBy<U>(Iterator<U> other, int Function(int, U) f) {
    return RIterator.fromIterable(_rangeWithStep($1, $2, $3)).cmpBy(other, f);
  }

  @pragma("vm:prefer-inline")
  List<int> collectList({bool growable = true}) {
    return RIterator.fromIterable(_rangeWithStep($1, $2, $3)).collectList(growable: growable);
  }

  @pragma("vm:prefer-inline")
  Set<int> collectSet() {
    return RIterator.fromIterable(_rangeWithStep($1, $2, $3)).collectSet();
  }

  @pragma("vm:prefer-inline")
  int count() {
    return RIterator.fromIterable(_rangeWithStep($1, $2, $3)).count();
  }

  @pragma("vm:prefer-inline")
  Cycle<int> cycle() {
    return RIterator.fromIterable(_rangeWithStep($1, $2, $3)).cycle();
  }

  @pragma("vm:prefer-inline")
  RIterator<(int, int)> enumerate() {
    return RIterator.fromIterable(_rangeWithStep($1, $2, $3)).enumerate();
  }

  @pragma("vm:prefer-inline")
  bool eq<U>(Iterator<U> other) {
    return RIterator.fromIterable(_rangeWithStep($1, $2, $3)).eq(other);
  }

  @pragma("vm:prefer-inline")
  bool eqBy<U>(Iterator<U> other, bool Function(int, U) f) {
    return RIterator.fromIterable(_rangeWithStep($1, $2, $3)).eqBy(other, f);
  }

  @pragma("vm:prefer-inline")
  RIterator<int> filter(bool Function(int) f) {
    return RIterator.fromIterable(_rangeWithStep($1, $2, $3)).filter(f);
  }

  @pragma("vm:prefer-inline")
  RIterator<U> filterMap<U extends Object>(Option<U> Function(int) f) {
    return RIterator.fromIterable(_rangeWithStep($1, $2, $3)).filterMap(f);
  }

  @pragma("vm:prefer-inline")
  Option<int> find(bool Function(int) f) {
    return RIterator.fromIterable(_rangeWithStep($1, $2, $3)).find(f);
  }

  @pragma("vm:prefer-inline")
  Option<U> findMap<U extends Object>(Option<U> Function(int) f) {
    return RIterator.fromIterable(_rangeWithStep($1, $2, $3)).findMap(f);
  }

  @pragma("vm:prefer-inline")
  FlatMap<int, U> flatMap<U>(Iterator<U> Function(int) f) {
    return RIterator.fromIterable(_rangeWithStep($1, $2, $3)).flatMap(f);
  }

  @pragma("vm:prefer-inline")
  RIterator<int> inspect(void Function(int) f) {
    return RIterator.fromIterable(_rangeWithStep($1, $2, $3)).inspect(f);
  }

  @pragma("vm:prefer-inline")
  RIterator<int> intersperse(int element) {
    return RIterator.fromIterable(_rangeWithStep($1, $2, $3)).intersperse(element);
  }

  @pragma("vm:prefer-inline")
  RIterator<int> intersperseWith(int Function() f) {
    return RIterator.fromIterable(_rangeWithStep($1, $2, $3)).intersperseWith(f);
  }

  @pragma("vm:prefer-inline")
  bool isPartitioned(bool Function(int) f) {
    return RIterator.fromIterable(_rangeWithStep($1, $2, $3)).isPartitioned(f);
  }

  @pragma("vm:prefer-inline")
  bool isSortedBy(int Function(int, int) f) {
    return RIterator.fromIterable(_rangeWithStep($1, $2, $3)).isSortedBy(f);
  }

  @pragma("vm:prefer-inline")
  bool isSortedByKey<U extends Comparable<U>>(U Function(int) f) {
    return RIterator.fromIterable(_rangeWithStep($1, $2, $3)).isSortedByKey(f);
  }

  @pragma("vm:prefer-inline")
  Option<int> lastOrOption() {
    return RIterator.fromIterable(_rangeWithStep($1, $2, $3)).lastOrOption();
  }

  @pragma("vm:prefer-inline")
  RIterator<U> mapWhile<U extends Object>(Option<U> Function(int) f) {
    return RIterator.fromIterable(_rangeWithStep($1, $2, $3)).mapWhile(f);
  }

  @pragma("vm:prefer-inline")
  RIterator<U> mapWindows<U>(int size, U Function(Arr<int>) f) {
    return RIterator.fromIterable(_rangeWithStep($1, $2, $3)).mapWindows(size, f);
  }

  @pragma("vm:prefer-inline")
  Option<int> maxBy(int Function(int, int) f) {
    return RIterator.fromIterable(_rangeWithStep($1, $2, $3)).maxBy(f);
  }

  @pragma("vm:prefer-inline")
  Option<int> maxByKey<U extends Comparable<U>>(U Function(int) f) {
    return RIterator.fromIterable(_rangeWithStep($1, $2, $3)).maxByKey(f);
  }

  @pragma("vm:prefer-inline")
  Option<int> minBy(int Function(int, int) f) {
    return RIterator.fromIterable(_rangeWithStep($1, $2, $3)).minBy(f);
  }

  @pragma("vm:prefer-inline")
  Option<int> minByKey<U extends Comparable<U>>(U Function(int) f) {
    return RIterator.fromIterable(_rangeWithStep($1, $2, $3)).minByKey(f);
  }

  @pragma("vm:prefer-inline")
  Result<Arr<int>, RIterator<int>> nextChunk(int size) {
    return RIterator.fromIterable(_rangeWithStep($1, $2, $3)).nextChunk(size);
  }

  @pragma("vm:prefer-inline")
  Option<int> nth(int n) {
    return RIterator.fromIterable(_rangeWithStep($1, $2, $3)).nth(n);
  }

  @pragma("vm:prefer-inline")
  (List<int>, List<int>) partition(bool Function(int) f) {
    return RIterator.fromIterable(_rangeWithStep($1, $2, $3)).partition(f);
  }

  @pragma("vm:prefer-inline")
  int partitionInPlace(bool Function(int) f) {
    return RIterator.fromIterable(_rangeWithStep($1, $2, $3)).partitionInPlace(f);
  }

  @pragma("vm:prefer-inline")
  Peekable<int> peekable() {
    return RIterator.fromIterable(_rangeWithStep($1, $2, $3)).peekable();
  }

  @pragma("vm:prefer-inline")
  Option<int> position(bool Function(int) f) {
    return RIterator.fromIterable(_rangeWithStep($1, $2, $3)).position(f);
  }

  @pragma("vm:prefer-inline")
  RIterator<int> rev() {
    return RIterator.fromIterable(_rangeWithStep($1, $2, $3)).rev();
  }

  @pragma("vm:prefer-inline")
  Option<int> rposition(bool Function(int) f) {
    return RIterator.fromIterable(_rangeWithStep($1, $2, $3)).rposition(f);
  }

  @pragma("vm:prefer-inline")
  RIterator<U> scan<U extends Object>(U initial, Option<U> Function(U, int) f) {
    return RIterator.fromIterable(_rangeWithStep($1, $2, $3)).scan(initial, f);
  }

  @pragma("vm:prefer-inline")
  Zip<int, U> zip<U>(Iterator<U> other) {
    return RIterator.fromIterable(_rangeWithStep($1, $2, $3)).zip(other);
  }
}

//************************************************************************//

Iterable<int> _range(int start, int end) sync* {
  if (start < end) {
    final step = 1;
    do {
      yield start;
      start += step;
    } while (start < end);
  } else {
    final step = -1;
    while (end < start) {
      yield start;
      start += step;
    }
  }
}

Iterable<int> _rangeWithStep(int start, int end, int? stepArg) sync* {
  if (start < end) {
    final int step;
    if (stepArg == null) {
      step = 1;
    } else {
      if (stepArg <= 0) {
        panic("'step' needs to be positive when start < end");
      }
      step = stepArg;
    }
    do {
      yield start;
      start += step;
    } while (start < end);
  } else {
    final int step;
    if (stepArg == null) {
      step = -1;
    } else {
      if (stepArg >= 0 && end < start) {
        panic("'step' needs to be negative when start > end");
      }
      step = stepArg;
    }
    while (end < start) {
      yield start;
      start += step;
    }
  }
}
