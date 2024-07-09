import 'package:rust_core/panic.dart';
import 'package:rust_core/slice.dart';

// https://stackoverflow.com/a/60358200
const int _intMaxValue = 9007199254740991;

sealed class Range implements Iterable<int> {
  const factory Range(int start, int end) = HalfOpenRange;

  Iterable<T> list<T>(List<T> list);

  Iterable<T> slice<T>(Slice<T> slice);

  bool get isAscending;
  bool get isDescending;
}

class HalfOpenRangeIterator implements Iterator<int> {
  final int start;
  final int end;
  final int _step;
  int _current;

  HalfOpenRangeIterator(this.start, this.end)
      : _current = start == end
            ? start
            : start < end
                ? start - 1
                : start + 1,
        _step = start == end
            ? 0
            : start < end
                ? 1
                : -1;

  @override
  int get current => _current;

  @override
  bool moveNext() {
    if (_current + _step == end) {
      return false;
    }
    _current += _step;
    return true;
  }
}

class HalfOpenRange extends Iterable<int> implements Range {
  final int start;
  final int end;

  const HalfOpenRange(this.start, this.end);

  bool get isAscending => end > start;
  bool get isDescending => end < start;

  @override
  HalfOpenRangeIterator get iterator => HalfOpenRangeIterator(start, end);

  @override
  Iterable<T> list<T>(List<T> list) sync* {
    if (end < 0 && start < 0) {
      panic("Range for list must be positive");
    }
    if (isAscending) {
      for (int i = start; i < end; i++) {
        yield list[i];
      }
    } else {
      for (int i = start; i > end; i--) {
        yield list[i];
      }
    }
  }

  @override
  Iterable<T> slice<T>(Slice<T> slice) sync* {
    final len = slice.len();
    if (end < 0 || start < 0) {
      panic("Range for slice must be positive");
    }
    if (isAscending) {
      if (len < end) {
        panic("Range is out of bounds for slice.");
      }
      for (int i = start; i < end; i++) {
        yield slice.getUnchecked(i);
      }
    } else {
      if (len < start) {
        panic("Range is out of bounds for slice.");
      }
      for (int i = start; i > end; i--) {
        yield slice.getUnchecked(i);
      }
    }
  }
}

class RangeFrom extends Iterable<int> implements Range {
  final int start;

  const RangeFrom(this.start);

  @override
  bool get isAscending => true;

  @override
  bool get isDescending => false;

  @override
  Iterator<int> get iterator => HalfOpenRangeIterator(start, _intMaxValue);

  @override
  Iterable<T> list<T>(List<T> list) sync* {
    if (start < 0) {
      panic("'start' for slice must be positive");
    }
    final len = list.length;
    for (int i = start; i < len; i++) {
      yield list[i];
    }
  }

  @override
  Iterable<T> slice<T>(Slice<T> slice) sync* {
    final len = slice.len();
    if (start < 0) {
      panic("'start' for slice must be positive");
    }
    for (int i = start; i < len; i++) {
      yield slice.getUnchecked(i);
    }
  }
}

// class RangeFull extends HalfOpenRange {
//   RangeFull(super.start, super.end);
// }

/// A generator over a range by a step size.
/// If [end] is not provided, range will be [0..startOrEnd), where [startOrEnd] can be positive or negative.
/// If [step] is not provided, step will be `-1` if `0 > startOrEnd` and `1` if `0 < startOrEnd`.
/// For reference, it works the same as the python `range` function.
/// ```dart
/// range(end); // == range(0,end);
/// range(start, end);
/// range(start, end, step);
/// ```
// Dev Note: inlined for parameter optimization
@pragma("vm:prefer-inline")
Iterable<int> range(int startOrEnd, [int? end, int? step]) sync* {
  assert(!(end == null && step != null),
      "'step' cannot be given if 'end' is null. Step will be ignored in release mode.");
  if (step == 0) {
    panic("'step' cannot be zero");
  }
  if (end == null) {
    int current = 0;
    if (startOrEnd > 0) {
      do {
        yield current;
        current++;
      } while (current < startOrEnd);
    } else {
      while (current > startOrEnd) {
        yield current;
        current--;
      }
    }
    return;
  }
  if (startOrEnd == end) {
    return;
  }
  if (startOrEnd < end) {
    if (step == null) {
      step = 1;
    } else if (step < 0) {
      panic("'step' needs to be positive when start < end");
    }
    do {
      yield startOrEnd;
      startOrEnd += step;
    } while (startOrEnd < end);
  } else {
    if (step == null) {
      step = -1;
    } else if (step > 0) {
      panic("'step' needs to be negative when start > end");
    }
    while (startOrEnd > end) {
      yield startOrEnd;
      startOrEnd += step;
    }
  }
}
