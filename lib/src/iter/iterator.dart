import 'package:rust_core/option.dart';
import 'package:rust_core/result.dart';
import 'package:rust_core/slice.dart';
import 'package:rust_core/array.dart';

part 'array_chunks.dart';
part 'chain.dart';
part 'peekable.dart';
part 'iterator_extensions.dart';
part 'iterator_interface.dart';
part 'cycle.dart';
part 'flat_map.dart';
part 'zip.dart';

/// RIterator is the union between an Iterator and an Iterable. Most iterator methods are consuming
/// and should be assumed to be so unless otherwise stated.
extension type RIterator<T>._(_BaseRIterator<T> _rIterator) implements _RIterator<T> {
  RIterator(Iterator<T> wrappedIterator) : _rIterator = _BaseRIterator(wrappedIterator);

  RIterator.fromIterable(Iterable<T> iterable) : _rIterator = _BaseRIterator.fromIterable(iterable);

  // Iterable: Overriding iterable methods
  //************************************************************************//

  /// Do not call. Will throw an error.
  /// Dev Note: Cannot remove since must implement iterable.
  @Deprecated("Is Not Supported as it would require consuming part of the iterator, which is likely not the users intent. Use peek() instead.")
  Never first() =>
      throw "First is not supported as it would require consuming part of the iterator, which is likely not the users intent. Use next() instead.";

  /// Do not call. Will throw an error.
  /// Dev Note: Cannot remove since must implement iterable.
  @Deprecated("Is Empty is not supported as it would require consuming part of the iterator, which is likely not the users intent. Use peek() instead.")
  Never isEmpty() =>
      throw "Is Empty is not supported as it would require consuming part of the iterator, which is likely not the users intent. Use peek() instead.";

  /// Do not call. Will throw an error.
  /// Dev Note: Cannot remove since must implement iterable.
  Never isNotEmpty() =>
      throw "Is Not Empty is not supported as it would require consuming part of the iterator, which is likely not the users intent. Use peek() instead.";

  /// Consumes the iterator, returning the last element of an iterator, None if empty.
  Option<T> last() {
    if (moveNext()) {
      var last = current;
      while (moveNext()) {
        last = current;
      }
      return Some(last);
    }
    return None;
  }

  /// Do not call. Will throw an error.
  /// Dev Note: Cannot remove since must implement iterable.
  @Deprecated("Length is not supported as it would require consuming the iterator, which is likely not the users intent. Use count() instead.")
  Never length() =>
      throw "Length is not supported as it would require consuming the iterator, which is likely not the users intent. Use count() instead.";

  /// Returns the single element of an iterator, None if this is empty or has more than one element.
  /// Dev Note: Cannot remove since must implement iterable.
  @Deprecated("Single is not supported as it would require consuming part of the iterator, which is likely not the users intent. Use next() instead.")
  Never single() => throw "Single is not supported as it would require consuming part of the iterator, which is likely not the users intent. Use next() instead.";

  // bool any(bool Function(T) f) {
  //   return iterable.any(f);
  // }

  /// Casts this RIterator<T> to an RIterator<U>.
  RIterator<U> cast<U>() => RIterator(_BaseRIterator.fromIterable(_rIterator.cast<U>()));

  // bool contains(Object? element) => iterable.contains(element);

  // T elementAt(int index) => iterable.elementAt(index);

  // bool every(bool Function(T) f) => iterable.every(f);

  /// Expands each element of this RIterator into zero or more elements.
  RIterator<U> expand<U>(RIterator<U> Function(T) f) =>
      RIterator(_BaseRIterator.fromIterable(_rIterator.expand(f)));

  // T firstWhere(bool Function(T) f, {T Function()? orElse}) => iterable.firstWhere(f, orElse: orElse);

  // U fold<U>(U initialValue, U Function(U previousValue, T element) f) => iterable.fold(initialValue, f);

  /// Creates the lazy concatenation of this Iterator and [other]
  RIterator<T> followedBy(Iterator<T> other) =>
      RIterator(_BaseRIterator.fromIterable(_rIterator.followedBy(other.iter())));

  // void forEach(void Function(T) f) => iterable.forEach(f);

  // String join([String separator = '']) => iterable.join(separator);

  // T lastWhere(bool Function(T) f, {T Function()? orElse}) => iterable.lastWhere(f, orElse: orElse);

  /// Maps each element of this RIterator to a new RIterator<U> using the function f.
  RIterator<U> map<U>(U Function(T) f) => RIterator(_BaseRIterator.fromIterable(_rIterator.map(f)));

  // T reduce(T Function(T, T) f) => iterable.reduce(f);

  // T singleWhere(bool Function(T) f, {T Function()? orElse}) => iterable.singleWhere(f, orElse: orElse);

  /// Skips the first [count] elements.
  RIterator<T> skip(int count) => RIterator(_BaseRIterator.fromIterable(_rIterator.skip(count)));

  /// Skips elements while [f] is true and returns the rest.
  RIterator<T> skipWhile(bool Function(T) f) =>
      RIterator(_BaseRIterator.fromIterable(_rIterator.skipWhile(f)));

  /// Returns the first [count] elements.
  RIterator<T> take(int count) => RIterator(_BaseRIterator.fromIterable(_rIterator.take(count)));

  /// Takes elements while [f] is true and returns the rest.
  RIterator<T> takeWhile(bool Function(T) f) =>
      RIterator(_BaseRIterator.fromIterable(_rIterator.takeWhile(f)));

  // List<T> toList({bool growable = true}) => iterable.toList(growable: growable);

  // Set<T> toSet() => iterable.toSet();

  // String toString() => iterable.toString();

  /// Creates an RIterator where all the elements satisfy the predicate [f].
  RIterator<T> where(bool Function(T) f) =>
      RIterator(_BaseRIterator.fromIterable(_rIterator.where(f)));

  /// Creates an RIterator where all the elements are of Type U.
  RIterator<U> whereType<U>() => RIterator(_BaseRIterator.fromIterable(_rIterator.whereType<U>()));
}

//************************************************************************//

/// Implementation of the RIterator interface.
/// Dev Note: This is private because some of the methods should not be use and are obscured or signatures changed by the RIterator interface.
class _BaseRIterator<T> extends Iterable<T> implements Iterator<T>, _RIterator<T> {
  // todo add protected
  late final Iterator<T> wIterator;

  _BaseRIterator(this.wIterator);

  _BaseRIterator.fromIterable(Iterable<T> iterable) : wIterator = iterable.iterator;

  _BaseRIterator.late();

  @override
  T get current => wIterator.current;

  @override
  bool moveNext() => wIterator.moveNext();

  @override
  Iterator<T> get iterator => wIterator;

  @override
  Option<T> next() {
    if (moveNext()) {
      return Some(current);
    }
    return None;
  }

  @override
  Result<(), int> advanceBy(int n) {
    for (var i = 0; i < n; i++) {
      if (!moveNext()) {
        return Err(n - i);
      }
    }
    return Ok(());
  }

  @override
  bool all(bool Function(T) f) => every(f);

  @override
  ArrayChunks<T> arrayChunks(int size) => ArrayChunks(wIterator, size);

  @override
  RIterator<T> chain(Iterator<T> other) => RIterator(Chain(this, other));

  @override
  int cmpBy<U>(Iterator<U> other, int Function(T, U) f) {
    //todo change to iterator
    while (true) {
      if (moveNext()) {
        if (other.moveNext()) {
          final cmp = f(current, other.current);
          if (cmp != 0) {
            return cmp;
          }
        } else {
          return 1;
        }
      } else {
        if (other.moveNext()) {
          return -1;
        }
        return 0;
      }
    }
  }

  @override
  List<T> collectList({bool growable = true}) {
    final list = <T>[];
    while (moveNext()) {
      list.add(current);
    }
    return list;
  }

  @override
  Set<T> collectSet() {
    final set = <T>{};
    while (moveNext()) {
      set.add(current);
    }
    return set;
  }

  Arr<T> collectArr() {
    final list = <T>[];
    while (moveNext()) {
      list.add(current);
    }
    return Arr.fromList(list);
  }

  @override
  int count() => length;

  @override
  Cycle<T> cycle() => Cycle(wIterator);

  @override
  RIterator<(int, T)> enumerate() => RIterator(_BaseRIterator.fromIterable(indexed));

  @override
  bool eq<U>(Iterator<U> other) {
    while (true) {
      if (moveNext()) {
        if (other.moveNext()) {
          if (current != other.current) {
            return false;
          }
        } else {
          return false;
        }
      } else {
        if (other.moveNext()) {
          return false;
        }
        return true;
      }
    }
  }

  @override
  bool eqBy<U>(Iterator<U> other, bool Function(T, U) f) {
    //todo change to iterator
    while (true) {
      if (iterator.moveNext()) {
        if (other.moveNext()) {
          if (!f(iterator.current, other.current)) {
            return false;
          }
        } else {
          return false;
        }
      } else {
        if (other.moveNext()) {
          return false;
        }
        return true;
      }
    }
  }

  @override
  RIterator<T> filter(bool Function(T) f) {
    return RIterator<T>(_BaseRIterator.fromIterable(where((element) => f(element))));
  }

  @override
  RIterator<U> filterMap<U>(Option<U> Function(T) f) {
    return RIterator(_BaseRIterator.fromIterable(_filterMapHelper(f)));
  }

  Iterable<U> _filterMapHelper<U>(Option<U> Function(T) f) sync* {
    for (final element in this) {
      final result = f(element);
      if (result.isSome()) {
        yield result.v!;
      }
    }
  }

  @override
  Option<T> find(bool Function(T) f) {
    for (final element in this) {
      if (f(element)) {
        return Some(element);
      }
    }
    return None;
  }

  @override
  Option<U> findMap<U>(Option<U> Function(T) f) {
    for (final element in this) {
      final result = f(element);
      if (result.isSome()) {
        return result;
      }
    }
    return None;
  }

  @override
  FlatMap<T,U> flatMap<U>(Iterator<U> Function(T) f) => FlatMap<T,U>(this, f);

  @override
  RIterator<T> inspect(void Function(T) f) {
    return RIterator(_BaseRIterator.fromIterable(_inspectHelper(f)));
  }

  Iterable<T> _inspectHelper(void Function(T) f) sync* {
    for (final element in this) {
      f(element);
      yield element;
    }
  }

  @override
  RIterator<T> intersperse(T element) {
    return RIterator(_BaseRIterator.fromIterable(_intersperseHelper(element)));
  }

  Iterable<T> _intersperseHelper(T element) sync* {
    final iterator = this.iterator;
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

  @override
  RIterator<T> intersperseWith(T Function() f) {
    return RIterator(_BaseRIterator.fromIterable(_intersperseWithHelper(f)));
  }

  Iterable<T> _intersperseWithHelper(T Function() f) sync* {
    final iterator = this.iterator;
    if (iterator.moveNext()) {
      var current = iterator.current;
      if (iterator.moveNext()) {
        yield current;
        current = iterator.current;
        if (iterator.moveNext()) {
          var next = iterator.current;
          while (iterator.moveNext()) {
            yield f();
            yield current;
            current = next;
            next = iterator.current;
          }
          yield f();
          yield current;
          yield f();
          yield next;
        } else {
          yield current;
        }
      } else {
        yield current;
      }
    }
  }

  @override
  RIterator<U> mapWhile<U>(Option<U> Function(T) f) {
    return RIterator(_BaseRIterator.fromIterable(_mapWhileHelper(f)));
  }

  Iterable<U> _mapWhileHelper<U>(Option<U> Function(T) f) sync* {
    for (final element in this) {
      final result = f(element);
      if (result.isSome()) {
        yield result.v!;
      } else {
        break;
      }
    }
  }

  @override
  Option<T> maxBy(int Function(T, T) f) {
    T max;
    if (moveNext()) {
      max = current;
    } else {
      return None;
    }
    for (final element in this) {
      if (f(element, max) > 0) {
        max = element;
      }
    }
    return Some(max);
  }

  @override
  Option<T> maxByKey<U extends Comparable<U>>(U Function(T) f) {
    T max;
    U maxVal;
    if (moveNext()) {
      max = current;
      maxVal = f(max);
    } else {
      return None;
    }
    for (final element in this) {
      final val = f(element);
      if (val.compareTo(maxVal) > 0) {
        max = element;
        maxVal = val;
      }
    }
    return Some(max);
  }

  @override
  Option<T> minBy(int Function(T, T) f) {
    T min;
    if (moveNext()) {
      min = current;
    } else {
      return None;
    }
    for (final element in this) {
      if (f(element, min) < 0) {
        min = element;
      }
    }
    return Some(min);
  }

  @override
  Option<T> minByKey<U extends Comparable<U>>(U Function(T) f) {
    T min;
    U minVal;
    if (moveNext()) {
      min = current;
      minVal = f(min);
    } else {
      return None;
    }
    for (final element in this) {
      final val = f(element);
      if (val.compareTo(minVal) < 0) {
        min = element;
        minVal = val;
      }
    }
    return Some(min);
  }

  @override
  Option<T> nth(int n) {
    if (n < 0) {
      return None;
    }
    var index = 0;
    for (final element in this) {
      if (index == n) {
        return Some(element);
      }
      index++;
    }
    return None;
  }

  @override
  (List<T>, List<T>) partition(bool Function(T) f) {
    final first = <T>[];
    final second = <T>[];
    for (final element in this) {
      if (f(element)) {
        first.add(element);
      } else {
        second.add(element);
      }
    }
    return (first, second);
  }

  @override
  Peekable<T> peekable() => Peekable(wIterator);

  @override
  Option<int> position(bool Function(T) f) {
    var index = 0;
    for (final element in this) {
      if (f(element)) {
        return Some(index);
      }
      index++;
    }
    return None;
  }

  @override
  RIterator<T> rev() => RIterator(_BaseRIterator.fromIterable(toList(growable: false).reversed));

  @override
  Option<int> rposition(bool Function(T) f) {
    final list = toList(growable: false).reversed;
    var index = list.length - 1;
    for (final element in list) {
      if (f(element)) {
        return Some(index);
      }
      index--;
    }
    return None;
  }

  @override
  RIterator<T> stepBy(int step) {
    assert(step > 0, 'Step must be greater than 0');
    return RIterator(_BaseRIterator.fromIterable(_stepByHelper(step)));
  }

  Iterable<T> _stepByHelper(int step) sync* {
    var index = 0;
    for (final element in this) {
      if (index % step == 0) {
        yield element;
      }
      index++;
    }
  }

  @override
  Zip<T, U> zip<U>(Iterator<U> other) => Zip<T, U>(this, other);
}
