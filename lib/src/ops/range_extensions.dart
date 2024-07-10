import 'package:rust_core/ops.dart';
import 'package:rust_core/slice.dart';

extension ListRangeExtension<T> on List<T> {
  @pragma("vm:prefer-inline")
  Slice<T> call(RangeBounds range) => range.slice(this);
}
