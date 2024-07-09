import 'package:rust_core/ops.dart';

extension ListRangeExtension<T> on List<T> {

  Iterable<T> call(Range range) sync* {
    if (range.isAscending) {
      for (int i = range.start; i < range.end; i++) {
        yield this[i];
      }
    }
    else {
      for (int i = range.start; i > range.end; i--) {
        yield this[i];
      }
    }
  }
}