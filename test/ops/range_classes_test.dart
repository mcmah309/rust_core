import 'package:rust_core/ops.dart';
import 'package:rust_core/panic.dart';
import 'package:test/test.dart';

void main() {
  group('Range', () {
    test('Range', () {
      expect(Range(5, 10).toList(), equals([5, 6, 7, 8, 9]));
      expect(Range(10, 5).toList(), equals([10, 9, 8, 7, 6]));
      expect(Range(5, 5).toList(), equals([]));
    });

    test('RangeFrom', () {
      expect(RangeFrom(5).take(5).toList(), equals([5, 6, 7, 8, 9]));
    });
  });
}
