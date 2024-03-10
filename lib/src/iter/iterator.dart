import 'package:rust_core/option.dart';
import 'package:rust_core/result.dart';
import 'package:rust_core/slice.dart';
import 'package:rust_core/array.dart';

part 'array_chunks.dart';
part 'cast.dart';
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
  late final Iterator<T> _wIterator;

  RIterator(this._wIterator);

  RIterator.fromIterable(Iterable<T> iterable) : _wIterator = iterable.iterator;

  RIterator.late();

  @override
  T get current => _wIterator.current;

  @override
  bool moveNext() => _wIterator.moveNext();

  @override
  Iterator<T> get iterator => _wIterator;

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
  ArrayChunks<T> arrayChunks(int size) => ArrayChunks(_wIterator, size);

  @override
  RIterator<T> chain(Iterator<T> other) => Chain(this, other);

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
  Cycle<T> cycle() => Cycle(_wIterator);

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
    return RIterator<T>(RIterator.fromIterable(where((element) => f(element))));
  }

  @override
  RIterator<U> filterMap<U>(Option<U> Function(T) f) {
    return RIterator.fromIterable(_filterMapHelper(f));
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
  RIterator<U> mapWhile<U>(Option<U> Function(T) f) {
    return RIterator.fromIterable(_mapWhileHelper(f));
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
  Peekable<T> peekable() => Peekable(_wIterator);

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
  RIterator<T> rev() => RIterator.fromIterable(toList(growable: false).reversed);

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
  Zip<T, U> zip<U>(Iterator<U> other) => Zip<T, U>(this, other);

  //************************************************************************//
  // Iterable: Overriding iterable methods
  //************************************************************************//

  /// Casts this RIterator<T> to an RIterator<U>.
  @override
  Cast<T,U> cast<U>() => Cast<T,U>(this);

  // bool contains(Object? element) => iterable.contains(element);

  // T elementAt(int index) => iterable.elementAt(index);

  // bool every(bool Function(T) f) => iterable.every(f);

  /// Expands each element of this RIterator into zero or more elements.
  @override
  FlatMap<T,U> expand<U>(Iterable<U> Function(T) f) => FlatMap<T,U>(this, (e) => f(e).iterator);

  // T firstWhere(bool Function(T) f, {T Function()? orElse}) => iterable.firstWhere(f, orElse: orElse);

  // U fold<U>(U initialValue, U Function(U previousValue, T element) f) => iterable.fold(initialValue, f);

  /// Creates the lazy concatenation of this Iterator and [other]
  @override
  Chain<T> followedBy(Iterable<T> other) => Chain(this, other.iterator);

  // void forEach(void Function(T) f) => iterable.forEach(f);

  // String join([String separator = '']) => iterable.join(separator);

  // T lastWhere(bool Function(T) f, {T Function()? orElse}) => iterable.lastWhere(f, orElse: orElse);

  /// Maps each element of this RIterator to a new RIterator<U> using the function f.
  @override
  Map<T,U> map<U>(U Function(T) f) => Map<T,U>(this, f);

  // T reduce(T Function(T, T) f) => iterable.reduce(f);

  // T singleWhere(bool Function(T) f, {T Function()? orElse}) => iterable.singleWhere(f, orElse: orElse);

  /// Consumes and skips the first [count] elements.
  @override
  RIterator<T> skip(int count) => RIterator.fromIterable(_skipHelper(count));

  Iterable<T> _skipHelper(int count) sync* {
    var index = 0;
    for (final element in this) {
      if (index >= count) {
        yield element;
      }
      index++;
    }
  }

  /// Consumes and skips elements while [f] is true and returns the rest.
  @override
  RIterator<T> skipWhile(bool Function(T) f) => RIterator.fromIterable(_skipWhileHelper(f));

  Iterable<T> _skipWhileHelper(bool Function(T) f) sync* {
    var skipping = true;
    for (final element in this) {
      if (skipping) {
        if (!f(element)) {
          skipping = false;
          yield element;
        }
      } else {
        yield element;
      }
    }
  }

  /// Takes the first [count] elements from the RIterator.
  @override
  RIterator<T> take(int count) => RIterator.fromIterable(_takeHelper(count));

  Iterable<T> _takeHelper(int count) sync* {
    var index = 0;
    while(index < count && moveNext()) {
      yield current;
      index++;
    }
  }

  /// TTakes the first [count] elements from the RIterator while [f] is true.
  @override
  RIterator<T> takeWhile(bool Function(T) f) => RIterator.fromIterable(_takeWhileHelper(f));

  Iterable<T> _takeWhileHelper(bool Function(T) f) sync* {
    for (final element in this) {
      if (f(element)) {
        yield element;
      } else {
        break;
      }
    }
  }

  // List<T> toList({bool growable = true}) => iterable.toList(growable: growable);

  // Set<T> toSet() => iterable.toSet();

  // String toString() => iterable.toString();

  /// Creates an RIterator where all the elements satisfy the predicate [f].
  @override
  RIterator<T> where(bool Function(T) f) => RIterator.fromIterable(_whereHelper(f));

  Iterable<T> _whereHelper(bool Function(T) f) sync* {
    for (final element in this) {
      if (f(element)) {
        yield element;
      }
    }
  }

  /// Creates an RIterator where all the elements are of Type U.
  @override
  RIterator<U> whereType<U>() => RIterator.fromIterable(_whereTypeHelper<U>());

  Iterable<U> _whereTypeHelper<U>() sync* {
    for (final element in this) {
      if (element is U) {
        yield element;
      }
    }
  }

  //************************************************************************//

  @override
  @Deprecated("Use next() instead. This consumes the first element of the iterator. Which is likely not the users intent.")
  T get first {
    assert(false, "Use next() instead. This consumes the first element of the iterator. Which is likely not the users intent.");
    return super.first;
  }

  @override
  @Deprecated("Use next() instead. This consumes the first element of the iterator. Which is likely not the users intent.")
  T get last {
    assert(false, "Use next() instead. This consumes the first element of the iterator. Which is likely not the users intent.");
    return super.last;
  }

  @override
  @Deprecated("Single is not supported as it would require consuming part of the iterator, which is likely not the users intent. Use peekable() instead.")
  T get single {
    assert(false, "Single is not supported as it would require consuming part of the iterator, which is likely not the users intent. Use peekable() instead.");
    return super.single;
  }

  @override
  @Deprecated("IsEmpty is not supported as it would require consuming part of the iterator, which is likely not the users intent. Use peekable() instead.")
  bool get isEmpty {
    assert(false, "IsEmpty is not supported as it would require consuming part of the iterator, which is likely not the users intent. Use peekable() instead.");
    return super.isEmpty;
  }

  @override
  @Deprecated("IsNotEmpty is not supported as it would require consuming part of the iterator, which is likely not the users intent. Use peekable() instead.")
  bool get isNotEmpty {
    assert(false, "IsNotEmpty is not supported as it would require consuming part of the iterator, which is likely not the users intent. Use peekable() instead.");
    return super.isNotEmpty;
  }

  @override
  @Deprecated("Length is not supported as it would require consuming the iterator, which is likely not the users intent. Use count() instead.")
  int get length {
    assert(false, "Length is not supported as it would require consuming the iterator, which is likely not the users intent. Use count() instead.");
    return super.length;
  }
}
