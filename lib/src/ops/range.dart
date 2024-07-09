
import 'package:rust_core/iter.dart';
import 'package:rust_core/panic.dart';

/// An iterator over the range [start..end), where start >= end or start <= end.
@pragma("vm:prefer-inline")
RIterator<int> range(int start, int end, [int? step]) {
  if (step == null) {
    return RIterator.fromIterable(_range(start, end));
  }
  return RIterator.fromIterable(_rangeWithStep(start, end, step));
}

@pragma("vm:prefer-inline")
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

@pragma("vm:prefer-inline")
Iterable<int> _rangeWithStep(int start, int end, int step) sync* {
  if (start < end) {
    if (step <= 0) {
      panic("'step' needs to be positive when start < end");
    }
    do {
      yield start;
      start += step;
    } while (start < end);
  } else {
    if (step >= 0 && end < start) {
      panic("'step' needs to be negative when start > end");
    }
    while (end < start) {
      yield start;
      start += step;
    }
  }
}
