import 'package:rust_core/iter.dart';
import 'package:rust_core/result.dart';
import 'package:rust_core/slice.dart';
import 'package:rust_core/option.dart';
import 'package:rust_core/src/iter/array_chunks.dart';

part 'iterator_extensions.dart';

extension type RIterator<T>(Iterable<T> iterable) implements Iterable<T> {
  RIterator.fromSlice(Slice<T> slice) : iterable = slice;

// advance_by: //todo

  bool all(bool Function(T) f) => iterable.every(f);

// any: Implemented by Iterable.any

  /// Returns an iterator over N elements of the iterator at a time.
  /// The chunks do not overlap. If N does not divide the length of the iterator, then the last up to N-1 elements will 
  /// be omitted and can be retrieved from the [.intoRemainder()] function of the iterator.
  ArrayChunks<T> arrayChunks(int size) => ArrayChunks(iterable, size);

// by_ref

  /// Takes two iterators and creates a new iterator over both in sequence.
  RIterator<T> chain(Iterable<T> other) {
    return RIterator(_chainHelper(other));
  }

  Iterable<T> _chainHelper(Iterable<T> other) sync* {
    yield* iterable;
    yield* other;
  }

// cloned
// cmp
// cmp_by
// collect: Will also be implemented by extensions

  List<T> collectList({bool growable = true}) {
    return iterable.toList(growable: growable);
  }

  Set<T> collectSet() {
    return iterable.toSet();
  }

// collect_into: Will not be implemented, no dart equivalent
// contains: Implemented by Iterable.contains
// copied: Will not be implemented, no dart equivalent

  /// Counting the number of iterations and returning it.
  int count() => iterable.length;

// cycle: //todo

  /// Creates an iterator which gives the current iteration count as well as the next value.
  RIterator<(int, T)> enumerate() => RIterator(iterable.indexed);

// eq
// eq_by

  /// Creates an iterator which uses a closure to determine if an element should be yielded.
  RIterator<T> filter(bool Function(T) f) {
    return RIterator<T>(iterable.where((element) => f(element)));
  }

  /// Creates an iterator that both filters and maps.
  /// The returned iterator yields only the values for which the supplied closure returns Some(value).
  RIterator<U> filterMap<U>(Option<U> Function(T) f) {
    return RIterator(_filterMapHelper(f));
  }

  Iterable<U> _filterMapHelper<U>(Option<U> Function(T) f) sync* {
    for (final element in iterable) {
      final result = f(element);
      if (result.isSome()) {
        yield result.v!;
      }
    }
  }

  /// Searches for an element of an iterator that satisfies a predicate.
  Option<T> find(bool Function(T) f) {
    for (final element in iterable) {
      if (f(element)) {
        return Some(element);
      }
    }
    return None;
  }

  /// Applies the function to the elements of iterator and returns the first non-none result.
  Option<U> findMap<U>(Option<U> Function(T) f) {
    for (final element in iterable) {
      final result = f(element);
      if (result.isSome()) {
        return result;
      }
    }
    return None;
  }

  /// Creates an iterator that works like map, but flattens nested structure.
  RIterator<U> flatMap<U>(Iterable<U> Function(T) f) {
    return RIterator(iterable.expand(f));
  }

// flatten: Implemented in an extension
// fold: Implemented by Iterable.fold
// for_each: Implemented by Iterable.forEach
// fuse: Implemented in an extension
// ge
// gt

  /// Does something with each element of an iterator, passing the value on.
  RIterator<T> inspect(void Function(T) f) {
    return RIterator(_inspectHelper(f));
  }

  Iterable<T> _inspectHelper(void Function(T) f) sync* {
    for (final element in iterable) {
      f(element);
      yield element;
    }
  }

  /// Creates a new iterator which places a separator between adjacent items of the original iterator.
  /// Similar to join with strings.
  RIterator<T> intersperse(T element) {
    return RIterator(_intersperseHelper(element));
  }

  Iterable<T> _intersperseHelper(T element) sync* {
    final iterator = iterable.iterator;
    if (iterator.moveNext()) {
      var current = iterator.current;
      if (iterator.moveNext()) {
        yield current;
        current = iterator.current;
        if (iterator.moveNext()) {
          var next = iterator.current;
          while (iterator.moveNext()) {
            yield element;
            yield current;
            current = next;
            next = iterator.current;
          }
          yield element;
          yield current;
          yield element;
          yield next;
        } else {
          yield element;
        }
      } else {
        yield current;
      }
    }
  }

// intersperse_with
// is_partitioned
// is_sorted
// is_sorted_by
// is_sorted_by_key
// last: Implemented by Iterable.last

  /// Returns the last element of an iterator, or None if it is empty.
  Option<T> lastOrOption() {
    if (iterable.isEmpty) {
      return None;
    }
    return Some(iterable.last);
  }

// le
// lt
// map: Implemented by Iterable.map

  /// Creates an iterator that both yields elements based on a predicate and maps.
  /// It will call this closure on each element of the iterator, and yield elements while it returns Some(_).
  RIterator<U> mapWhile<U>(Option<U> Function(T) f) {
    return RIterator(_mapWhileHelper(f));
  }

  Iterable<U> _mapWhileHelper<U>(Option<U> Function(T) f) sync* {
    for (final element in iterable) {
      final result = f(element);
      if (result.isSome()) {
        yield result.v!;
      } else {
        break;
      }
    }
  }


// map_windows
// max: // todo in an extesion

  /// Returns the element that gives the maximum value with respect to the specified comparison function.
  Option<T> maxBy(int Function(T,T) f){
    if (iterable.isEmpty) {
      return None;
    }
    var max = iterable.first;
    for (final element in iterable) {
      if (f(element, max) > 0) {
        max = element;
      }
    }
    return Some(max);
  }

  /// Returns the element that gives the maximum value from the specified function.
  Option<T> maxByKey<U extends Comparable<U>>(U Function(T) f) {
    if (iterable.isEmpty) {
      return None;
    }
    var max = iterable.first;
    var maxVal = f(max);
    for (final element in iterable) {
      final val = f(element);
      if (val.compareTo(maxVal) > 0) {
        max = element;
        maxVal = val;
      }
    }
    return Some(max);
  }

// min: // todo in an extesion

  /// Returns the element that gives the minimum value with respect to the specified comparison function.
  Option<T> minBy(int Function(T,T) f){
    if (iterable.isEmpty) {
      return None;
    }
    var min = iterable.first;
    for (final element in iterable) {
      if (f(element, min) < 0) {
        min = element;
      }
    }
    return Some(min);
  }

  /// Returns the element that gives the minimum value from the specified function.
  Option<T> minByKey<U extends Comparable<U>>(U Function(T) f) {
    if (iterable.isEmpty) {
      return None;
    }
    var min = iterable.first;
    var minVal = f(min);
    for (final element in iterable) {
      final val = f(element);
      if (val.compareTo(minVal) < 0) {
        min = element;
        minVal = val;
      }
    }
    return Some(min);
  }

// ne
// next_chunk

  /// Returns the nth element of the iterator.
  /// Like most indexing operations, the count starts from zero, so nth(0) returns the first value, nth(1) the second, and so on.
  /// nth() will return None if n is greater than or equal to the length of the iterator.
  Option<T> nth(int n) {
    if (n < 0) {
      return None;
    }
    var index = 0;
    for (final element in iterable) {
      if (index == n) {
        return Some(element);
      }
      index++;
    }
    return None;
  }

// partial_cmp
// partial_cmp_by

  /// Consumes an iterator, creating two collections from it.
  /// partition() returns a pair, all of the elements for which it returned true, and all of the elements for which it returned false.
  (List<T>, List<T>) partition(bool Function(T) f) {
    final first = <T>[];
    final second = <T>[];
    for (final element in iterable) {
      if (f(element)) {
        first.add(element);
      } else {
        second.add(element);
      }
    }
    return (first, second);
  }

// partition_in_place: Will not implement, not possible in Dart

  /// Creates an iterator which can use the "peek" to look at the next element of the iterator without consuming it.
  Peekable<T> peekable() => Peekable(iterable);


  /// Searches for an element in an iterator, returning its index.
  Option<int> position(bool Function(T) f) {
    var index = 0;
    for (final element in iterable) {
      if (f(element)) {
        return Some(index);
      }
      index++;
    }
    return None;
  }

// product
// reduce: Implemented by Iterable.reduce

  /// Reverses the iterable
  RIterator<T> rev() => RIterator(iterable.toList(growable: false).reversed);

  /// Searches for an element in an iterator from the right, returning its index.
  /// Recommended to use with a list, as it is more efficient, otherwise use [position].
  Option<int> rposition(bool Function(T) f) {
    var index = iterable.length - 1;
    final self = this.iterable;
    if(self is List<T>){
      for (var i = self.length - 1; i >= 0; i--) {
        if (f(self[i])) {
          return Some(i);
        }
      }
      return None;
    }
    for (final element in iterable.toList(growable: false).reversed) {
      if (f(element)) {
        return Some(index);
      }
      index--;
    }
    return None;
  }

// scan: //todo
// size_hint
// skip: Implemented by Iterable.skip
// skip_while: Implemented by Iterable.skipWhile

  /// Creates an iterator starting at the same point, but stepping by the given amount at each iteration.
  RIterator<T> stepBy(int step) {
    assert(step > 0, 'Step must be greater than 0');
    return RIterator(_stepByHelper(step));
  }

  Iterable<T> _stepByHelper(int step) sync* {
    var index = 0;
    for (final element in iterable) {
      if (index % step == 0) {
        yield element;
      }
      index++;
    }
  }

// sum
// take: Implemented by Iterable.take
// take_while: Implemented by Iterable.takeWhile
// try_collect
// try_find
// try_fold
// try_for_each
// try_reduce
// unzip: Implemented in extension

  /// Zips this iterator with another and yields pairs of elements.
  /// The first element comes from the first iterator, and the second element comes from the second iterator.
  /// If either iterator does not have another element, the iterator stops.
  RIterator<(T, U)> zip<U>(Iterable<U> other) => RIterator(Zip<T, U>(this.iterable, other));

  // Iterable: Overriding iterable methods
  //************************************************************************//

  /// Returns the first element of an iterator, None if empty.
  Option<T> first() {
    final first = iterable.firstOrNull;
    if (first == null) {
      return None;
    }
    return Some(first);
  }

  /// Returns true if the iterator is empty, false otherwise.
  bool isEmpty() => iterable.isEmpty;

  /// Returns true if the iterator is not empty, false otherwise.
  bool isNotEmpty() => iterable.isNotEmpty;

  Iterator<T> get iterator => iterable.iterator;

  /// Returns the last element of an iterator, None if empty.
  Option<T> last() {
    final last = iterable.lastOrNull;
    if (last == null) {
      return None;
    }
    return Some(last);
  }

  /// Returns the length of an iterator.
  int length() => iterable.length;

  /// Returns the single element of an iterator, None if this is empty or has more than one element.
  Option<T> single() {
    final firstTwo = iterable.take(2).iterator;
    if (!firstTwo.moveNext()) {
      return None;
    }
    final first = firstTwo.current;
    if (!firstTwo.moveNext()) {
      return Some(first);
    }
    return None;
  }

  // bool any(bool Function(T) f) {
  //   return iterable.any(f);
  // }

  RIterator<U> cast<U>() => RIterator(iterable.cast<U>());

  // bool contains(Object? element) => iterable.contains(element);

  // T elementAt(int index) => iterable.elementAt(index);

  // bool every(bool Function(T) f) => iterable.every(f);

    RIterator<U> expand<U>(Iterable<U> Function(T) f) => RIterator(iterable.expand(f));

  // T firstWhere(bool Function(T) f, {T Function()? orElse}) => iterable.firstWhere(f, orElse: orElse);

  // U fold<U>(U initialValue, U Function(U previousValue, T element) f) => iterable.fold(initialValue, f);

  RIterator<T> followedBy(Iterable<T> other) => RIterator(iterable.followedBy(other));

  // void forEach(void Function(T) f) => iterable.forEach(f);

  // String join([String separator = '']) => iterable.join(separator);

  // T lastWhere(bool Function(T) f, {T Function()? orElse}) => iterable.lastWhere(f, orElse: orElse);

  RIterator<U> map<U>(U Function(T) f) => RIterator(iterable.map(f));

  // T reduce(T Function(T, T) f) => iterable.reduce(f);

  // T singleWhere(bool Function(T) f, {T Function()? orElse}) => iterable.singleWhere(f, orElse: orElse);

  RIterator<T> skip(int count) => RIterator(iterable.skip(count));

  RIterator<T> skipWhile(bool Function(T) f) => RIterator(iterable.skipWhile(f));

  RIterator<T> take(int count) => RIterator(iterable.take(count));

  RIterator<T> takeWhile(bool Function(T) f) => RIterator(iterable.takeWhile(f));

  // List<T> toList({bool growable = true}) => iterable.toList(growable: growable);

  // Set<T> toSet() => iterable.toSet();

  // String toString() => iterable.toString();

  RIterator<T> where(bool Function(T) f) => RIterator(iterable.where(f));

  RIterator<U> whereType<U>() => RIterator(iterable.whereType<U>());
}
