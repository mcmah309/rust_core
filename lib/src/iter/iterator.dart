import 'package:meta/meta.dart';
import 'package:rust_core/iter.dart';
import 'package:rust_core/option.dart';
import 'package:rust_core/result.dart';
import 'package:rust_core/array.dart';

part 'array_chunks.dart';
part 'cast.dart';
part 'clone.dart';
part 'chain.dart';
part 'peekable.dart';
part 'iterator_extensions.dart';
part 'iterator_interface.dart';
part 'map.dart';
part 'cycle.dart';
part 'flat_map.dart';
part 'zip.dart';

/// RIterator is the union between an Iterator and an Iterable. Most iterator methods are consuming
/// and should be assumed to be so unless otherwise stated.
class RIterator<T> extends Iterable<T> implements Iterator<T>, _RIterator<T> {
  late Iterator<T> _wIterator;

  RIterator(this._wIterator);

  RIterator.fromIterable(Iterable<T> iterable) : _wIterator = iterable.iterator;

  RIterator._late();

  @override
  T get current => _wIterator.current;

  @override
  bool moveNext() => _wIterator.moveNext();

  @override
  Iterator<T> get iterator => _wIterator;

  @override
  operator ==(Object other) {
    return other is RIterator<T> && other._wIterator == _wIterator;
  }

  @override
  int get hashCode => _wIterator.hashCode;

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
  ArrayChunksRIterator<T> arrayChunks(int size) =>
      ArrayChunksRIterator(this, size);

  @override
  ChainRIterator<T> chain(Iterator<T> other) => ChainRIterator(this, other);

  @override
  int cmpBy<U>(Iterator<U> other, int Function(T, U) f) {
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
  RIterator<T> clone(){
    if(this is CloneRIterator<T>){
      return CloneRIterator._clone(this as CloneRIterator<T>);
    }
    return CloneRIterator<T>._original(this);
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
  int count() => super.length;

  @override
  CycleRIterator<T> cycle() => CycleRIterator(this);

  @override
  RIterator<(int, T)> enumerate() => RIterator.fromIterable(indexed);

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
    return RIterator.fromIterable(where((f)));
  }

  @override
  RIterator<U> filterMap<U extends Object>(Option<U> Function(T) f) {
    return RIterator.fromIterable(_filterMapHelper(f));
  }

  Iterable<U> _filterMapHelper<U extends Object>(
      Option<U> Function(T) f) sync* {
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
  Option<U> findMap<U extends Object>(Option<U> Function(T) f) {
    for (final element in this) {
      final result = f(element);
      if (result.isSome()) {
        return result;
      }
    }
    return None;
  }

  @override
  FlatMapRIterator<T, U> flatMap<U>(Iterator<U> Function(T) f) =>
      FlatMapRIterator<T, U>(this, f);

  @override
  RIterator<T> inspect(void Function(T) f) {
    return RIterator.fromIterable(_inspectHelper(f));
  }

  Iterable<T> _inspectHelper(void Function(T) f) sync* {
    for (final element in this) {
      f(element);
      yield element;
    }
  }

  @override
  RIterator<T> intersperse(T element) {
    return RIterator.fromIterable(_intersperseHelper(element));
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
  bool isPartitioned(bool Function(T) f) {
    var foundFalse = false;
    for (final element in this) {
      if (f(element)) {
        if (foundFalse) {
          return false;
        }
      } else {
        foundFalse = true;
      }
    }
    return true;
  }

  @override
  bool isSortedBy(int Function(T, T) f) {
    T prev;
    if (moveNext()) {
      prev = current;
    } else {
      return true;
    }
    for (final element in this) {
      if (f(prev, element) > 0) {
        return false;
      }
      prev = element;
    }
    return true;
  }

  @override
  bool isSortedByKey<U extends Comparable<U>>(U Function(T) f) {
    U prev;
    if (moveNext()) {
      prev = f(current);
    } else {
      return true;
    }
    for (final element in this) {
      final val = f(element);
      if (prev.compareTo(val) > 0) {
        return false;
      }
      prev = val;
    }
    return true;
  }

  @override
  RIterator<T> intersperseWith(T Function() f) {
    return RIterator.fromIterable(_intersperseWithHelper(f));
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
  Option<T> lastOrOption() {
    if (moveNext()) {
      var last = current;
      while (moveNext()) {
        last = current;
      }
      return Some(last);
    }
    return None;
  }

  @override
  RIterator<U> mapWhile<U extends Object>(Option<U> Function(T) f) {
    return RIterator.fromIterable(_mapWhileHelper(f));
  }

  Iterable<U> _mapWhileHelper<U extends Object>(Option<U> Function(T) f) sync* {
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
  RIterator<U> mapWindows<U>(int size, U Function(Arr<T>) f) {
    assert(size > 0, "Size must be greater than 0");
    return RIterator.fromIterable(_mapWindowsHelper(size, f));
  }

  Iterable<U> _mapWindowsHelper<U>(int size, U Function(Arr<T>) f) sync* {
    final window = Arr<T?>(null, size);
    int index = 0;
    int lastIndex = size - 1;
    while (moveNext()) {
      window[index] = current;
      index++;
      if (index == size) {
        index = lastIndex;
        yield f(window.cast<T>());
        T? newest = window[lastIndex];
        T? secondNewest;
        for (int j = lastIndex; j > 0; j--) {
          secondNewest = window[j - 1];
          window[j - 1] = newest;
          newest = secondNewest;
        }
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
  Result<Arr<T>, RIterator> nextChunk(int size) {
    final arr = Arr<T?>(null, size);
    for (var i = 0; i < size; i++) {
      if (!moveNext()) {
        return Err(this);
      }
      arr[i] = current;
    }
    return Ok(arr.cast<T>());
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
  int partitionInPlace(bool Function(T) f) {
    final list = toList(growable: false);
    var i = 0;
    var j = list.length - 1;
    while (i < j) {
      if (f(list[i])) {
        i++;
      } else {
        final temp = list[i];
        list[i] = list[j];
        list[j] = temp;
        j--;
      }
    }
    _wIterator = list.iterator;
    return i;
  }

  @override
  PeekableRIterator<T> peekable() => PeekableRIterator(this);

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
  RIterator<T> rev() =>
      RIterator.fromIterable(toList(growable: false).reversed);

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
  RIterator<U> scan<U extends Object>(U initial, Option<U> Function(U, T) f) {
    return RIterator.fromIterable(_scanHelper(initial, f));
  }

  Iterable<U> _scanHelper<U extends Object>(
      U initial, Option<U> Function(U, T) f) sync* {
    var current = initial;
    for (final element in this) {
      final result = f(current, element);
      if (result.isSome()) {
        current = result.v as U;
        yield current;
      } else {
        break;
      }
    }
  }

  @override
  RIterator<T> stepBy(int step) {
    assert(step > 0, 'Step must be greater than 0');
    return RIterator.fromIterable(_stepByHelper(step));
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
  ZipRIterator<T, U> zip<U>(Iterator<U> other) =>
      ZipRIterator<T, U>(this, other);

  //************************************************************************//
  // Iterable: Overriding iterable methods
  //************************************************************************//

  /// Casts this RIterator<T> to an RIterator<U>.
  @override
  RIterator<U> cast<U>() => RIterator.fromIterable(super.cast<U>());

  // bool contains(Object? element) => iterable.contains(element);

  // T elementAt(int index) => iterable.elementAt(index);

  // bool every(bool Function(T) f) => iterable.every(f);

  /// Expands each element of this RIterator into zero or more elements.
  @override
  RIterator<U> expand<U>(Iterable<U> Function(T) f) =>
      RIterator.fromIterable(super.expand(f));

  // T firstWhere(bool Function(T) f, {T Function()? orElse}) => iterable.firstWhere(f, orElse: orElse);

  // U fold<U>(U initialValue, U Function(U previousValue, T element) f) => iterable.fold(initialValue, f);

  /// Creates the lazy concatenation of this Iterator and [other]
  @override
  RIterator<T> followedBy(Iterable<T> other) =>
      RIterator.fromIterable(super.followedBy(other));

  // void forEach(void Function(T) f) => iterable.forEach(f);

  // String join([String separator = '']) => iterable.join(separator);

  // T lastWhere(bool Function(T) f, {T Function()? orElse}) => iterable.lastWhere(f, orElse: orElse);

  /// Maps each element of this RIterator to a new RIterator<U> using the function f.
  @override
  RIterator<U> map<U>(U Function(T) f) => RIterator.fromIterable(super.map(f));

  // T reduce(T Function(T, T) f) => iterable.reduce(f);

  // T singleWhere(bool Function(T) f, {T Function()? orElse}) => iterable.singleWhere(f, orElse: orElse);

  /// Consumes and skips the first [count] elements.
  @override
  RIterator<T> skip(int count) => RIterator.fromIterable(super.skip(count));

  /// Consumes and skips elements while [f] is true and returns the rest.
  @override
  RIterator<T> skipWhile(bool Function(T) f) =>
      RIterator.fromIterable(super.skipWhile(f));

  /// Takes the first [count] elements from the RIterator.
  @override
  RIterator<T> take(int count) => RIterator.fromIterable(super.take(count));

  /// TTakes the first [count] elements from the RIterator while [f] is true.
  @override
  RIterator<T> takeWhile(bool Function(T) f) =>
      RIterator.fromIterable(super.takeWhile(f));

  // List<T> toList({bool growable = true}) => iterable.toList(growable: growable);

  // Set<T> toSet() => iterable.toSet();

  // String toString() => iterable.toString();

  /// Creates an RIterator where all the elements satisfy the predicate [f].
  @override
  RIterator<T> where(bool Function(T) f) =>
      RIterator.fromIterable(super.where(f));

  /// Creates an RIterator where all the elements are of Type U.
  @override
  RIterator<U> whereType<U>() => RIterator.fromIterable(super.whereType());

  //************************************************************************//

  @override
  @Deprecated(
      "Use next() instead. This consumes the first element of the iterator. Which is likely not the users intent.")
  T get first {
    assert(false,
        "Use next() instead. This consumes the first element of the iterator. Which is likely not the users intent.");
    return super.first;
  }

  @override
  @Deprecated(
      "Use next() instead. This consumes the first element of the iterator. Which is likely not the users intent.")
  T get last {
    assert(false,
        "Use next() instead. This consumes the first element of the iterator. Which is likely not the users intent.");
    return super.last;
  }

  @override
  @Deprecated(
      "Single is not supported as it would require consuming part of the iterator, which is likely not the users intent. Use peekable() instead.")
  T get single {
    assert(false,
        "Single is not supported as it would require consuming part of the iterator, which is likely not the users intent. Use peekable() instead.");
    return super.single;
  }

  @override
  @Deprecated(
      "IsEmpty is not supported as it would require consuming part of the iterator, which is likely not the users intent. Use peekable() instead.")
  bool get isEmpty {
    assert(false,
        "IsEmpty is not supported as it would require consuming part of the iterator, which is likely not the users intent. Use peekable() instead.");
    return super.isEmpty;
  }

  @override
  @Deprecated(
      "IsNotEmpty is not supported as it would require consuming part of the iterator, which is likely not the users intent. Use peekable() instead.")
  bool get isNotEmpty {
    assert(false,
        "IsNotEmpty is not supported as it would require consuming part of the iterator, which is likely not the users intent. Use peekable() instead.");
    return super.isNotEmpty;
  }

  @override
  @Deprecated(
      "Length is not supported as it would require consuming the iterator, which is likely not the users intent. Use count() instead.")
  int get length {
    assert(false,
        "Length is not supported as it would require consuming the iterator, which is likely not the users intent. Use count() instead.");
    return super.length;
  }
}
