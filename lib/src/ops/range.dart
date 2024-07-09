import 'package:rust_core/iter.dart';
import 'package:rust_core/panic.dart';

/// A generator over a range by a step size.
/// If [end] is not provided, range will be [0..startOrEnd), where [startOrEnd] can be positive or negative.
/// If [step] is not provided, step will be `-1` if `0 > startOrEnd` and `1` if `0 < startOrEnd`.
/// For reference, it works the same as the python `range` function.
/// ```dart
/// range(end); // == range(0,end);
/// range(start, end);
/// range(start, end, step);
/// ```
/// 
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
