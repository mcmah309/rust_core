import 'package:rust_core/array.dart';
import 'package:rust_core/iter.dart';
import 'package:rust_core/rust_core.dart';

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
  }
  else {
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
