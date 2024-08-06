import 'package:rust_core/iter.dart';
import 'package:rust_core/slice.dart';
import 'package:rust_core/option.dart';

import 'extract_if.dart';

typedef Vec<T> = List<T>;

/// A contiguous **growable** array type, written as Vec<T>, short for ‘vector’.
extension ListVec<T> on List<T> {
// allocator: will not be implemented

  /// Adds all of other's elements to this Vec.
  @pragma('vm:prefer-inline')
  void append(List<T> other) => addAll(other);

// as_mut_ptr: will not be implemented
// as_mut_slice: will not be implemented
// as_ptr: will not be implemented

// capacity: will not be implemented, not possible
// clear: already implemented by List

// clone: will not be implemented, not possible

  /// Removes consecutive repeated elements in the vector according to `==`. If the vector is sorted, this removes all duplicates.
  void dedup() {
    late T last;
    bool first = true;
    removeWhere((element) {
      if (first) {
        last = element;
        first = false;
        return false;
      }
      if (element == last) {
        return true;
      }
      last = element;
      return false;
    });
  }

  /// Removes all but the first of consecutive elements in the vector satisfying a given equality relation. If the vector is sorted, this removes all duplicates.
  void dedupBy(bool Function(T a, T b) f) {
    late T last;
    bool first = true;
    removeWhere((element) {
      if (first) {
        last = element;
        first = false;
        return false;
      }
      if (f(element, last)) {
        return true;
      }
      last = element;
      return false;
    });
  }

  /// Removes all but the first of consecutive elements in the vector for which the given predicate returns true. If the vector is sorted, this removes all duplicates.
  void dedupByKey<K>(K Function(T) f) {
    late K last;
    bool first = true;
    removeWhere((element) {
      if (first) {
        last = f(element);
        first = false;
        return false;
      }
      if (f(element) == last) {
        return true;
      }
      last = f(element);
      return false;
    });
  }

  /// Removes the element at the given index from the Vec and returns it.
  @pragma('vm:prefer-inline')
  Vec<T> drain(int start, int end) {
    final range = getRange(start, end).toList();
    removeRange(start, end);
    return range;
  }

  /// Appends all elements in a slice to the Vec.
  @pragma('vm:prefer-inline')
  void extendFromSlice(Slice<T> slice) => addAll(slice);

  // Appends all the elements in range to the end of the vector.
  @pragma('vm:prefer-inline')
  void extendFromWithin(int start, int end) => addAll(getRange(start, end));

  /// Creates an [RIterator] which uses a closure to determine if an element should be removed.
  /// If the closure returns true, then the element is removed and yielded. If the closure returns false,
  /// the element will remain in the vector and will not be yielded by the iterator.
  @pragma('vm:prefer-inline')
  RIterator<T> extractIf(bool Function(T) f) =>
      RIterator.fromIterable(ExtractIfIterable(this, f));

// from_raw_parts: will not be implemented, not possible
// from_raw_parts_in: will not be implemented, not possible
  /// insert: Already implemented by list
// into_boxed_slice: will not implement, box is not a thing in dart
// into_flattened: Added as extension
// into_raw_parts: will not be implemented, not possible
// into_raw_parts_with_alloc: will not be implemented, not possible
// is_empty: Implemented by Iterable.isEmpty
// leak: will not be implemented, not possible

  /// Returns the length of the Vec.
  /// Equivalent to [length].
  @pragma('vm:prefer-inline')
  int len() => length;

// new: will not not implement, already has a constructor
// new_in: will not implement, not possible

  /// Removes the last element from the Vec and returns it, or None if it is empty.
  @pragma('vm:prefer-inline')
  Option<T> pop() {
    if (isEmpty) {
      return None;
    }
    return Some(removeLast());
  }

  /// Appends an element to the end of the Vec.
  /// Equivalent to [add].
  @pragma('vm:prefer-inline')
  void push(T element) => add(element);

// push_within_capacity: will not implement, no point
// remove: implemented as `removeAt` in List

// reserve: Will not implement, would require another param to keep track of allocation vs vec size
// reserve_exact: Will not implement, not possible

  /// Resizes the Vec in-place so that len is equal to [newLen].
  /// If [newLen] is greater than len, the Vec is extended by the difference,
  /// with each additional slot filled with value. If new_len is less than len,
  /// the Vec is simply truncated.
  void resize(int newLen, T value) {
    if (newLen > length) {
      final doFor = newLen - length;
      for (int i = 0; i < doFor; i++) {
        add(value);
      }
    } else {
      length = newLen;
    }
  }

  /// Resizes the Vec in-place so that len is equal to [newLen].
  /// If [newLen] is greater than len, the Vec is extended by the difference,
  /// with each additional slot filled with the result of f. If new_len is less than len,
  /// the Vec is simply truncated.
  void resizeWith(int newLen, T Function() f) {
    if (newLen > length) {
      final doFor = newLen - length;
      for (int i = 0; i < doFor; i++) {
        add(f());
      }
    } else {
      length = newLen;
    }
  }

  /// Retains only the elements specified by the predicate where the result is true.
  /// Equivalent to [retainWhere].
  @pragma('vm:prefer-inline')
  void retain(bool Function(T) f) => retainWhere(f);

// retain_mut: Will not implement, functionality implemented by `retain`
// set_len: Will not implement, not possible
// shrink_to: Will not implement, not possible
// shrink_to_fit: will not implement, not possible
// spare_capacity_mut: Will not implement, not possible

  /// Creates a splicing iterator that replaces the specified range in the vector with the given
  /// [replaceWith] iterator and yields the removed items. replace_with does not need to be the same length as range.
  // Dev Note: For the real functionality, we would need to implement a custom iterator that removes the section, then
  // adds items from [replaceWith] as it iterates over it, but this may end up being more computationally
  // expensive than just doing it eagerly.
  Vec<T> splice(int start, int end, Iterable<T> replaceWith) {
    final range = getRange(start, end).toList(growable: false);
    replaceRange(start, end, replaceWith);
    return range;
  }

// split_at_spare_mut: Will not implement, not possible

  /// Splits the collection into two at the given index.
  /// Returns a newly allocated vector containing the elements in the range
  /// [at, len). After the call, the original vector will be left containing the elements [0, at).
  Vec<T> splitOff(int at) {
    final split = sublist(at);
    removeRange(at, length);
    return split;
  }

  /// Removes an element from the vector and returns it.
  /// The removed element is replaced by the last element of the vector.
  T swapRemove(int index) {
    final removed = this[index];
    this[index] = removeLast();
    return removed;
  }

  /// Shortens the vector, keeping the first len elements and dropping the rest.
  @pragma('vm:prefer-inline')
  void truncate(int newLen) => length = newLen;

// try_reserve: Will not implement, would require another param to keep track of allocation vs vec size
// try_reserve_exact: Will not implement, not possible
// with_capacity_in: Will not implement, would require another param to keep track of allocation vs vec size

  //************************************************************************//

  @pragma('vm:prefer-inline')
  Iter<T> iter() => Iter(iterator);

  // Iterable: Overriding iterable methods
  //************************************************************************//

  /// Returns the first element of an iterator, None if empty.
  @pragma('vm:prefer-inline')
  Option<T> firstOrOption() => Option.from(firstOrNull);

// isEmpty: implemented by List
// isNotEmpty: implemented by List

  /// Returns the last element of an iterator, None if empty.
  @pragma('vm:prefer-inline')
  Option<T> lastOrOption() => Option.from(lastOrNull);

  /// Returns the single element of an iterator, None if this is empty or has more than one element.
  @pragma('vm:prefer-inline')
  Option<T> singleOrOption() => Option.from(singleOrNull);
}