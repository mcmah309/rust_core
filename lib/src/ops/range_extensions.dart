import 'package:rust_core/ops.dart';

extension ListRangeExtension<T> on List<T> {
  @pragma("vm:prefer-inline")
  Iterable<T> call(RangeBounds range) => range.list(this);
}
