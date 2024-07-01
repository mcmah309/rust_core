import 'package:rust_core/array.dart';

/// An array of ints in the range start..end contains all values with start <= x < end.
/// The edge conditions can be changes with [sInc] and [eInc].
/// [sInc] is whether the start is inclusive and [eInc] is whether the end is inclusive.
@pragma("vm:prefer-inline")
Arr<int> range(int start, int end, {bool sInc = true, bool eInc = false}) {
  if (!sInc) start += 1;
  if (eInc) end += 1;

  return Arr<int>.generate(end - start, (index) => start + index);
}
