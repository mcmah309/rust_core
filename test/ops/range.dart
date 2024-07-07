import 'package:rust_core/ops.dart';
import 'package:test/test.dart';

void main() {
  group('range', () {
    test('Range ascending', () {
      expect((5, 10).range().toList(), equals([5, 6, 7, 8, 9]));
      expect(range(5, 10).toList(), equals([5, 6, 7, 8, 9]));
    });

    test('Range descending', () {
      expect((10, 5).range().toList(), equals([10, 9, 8, 7, 6]));
      expect(range(10, 5).toList(), equals([10, 9, 8, 7, 6]));
    });

    test('Range equal', () {
      expect((5, 5).range().toList(), equals([]));
      expect(range(5, 5).toList(), equals([]));
    });
  });

  group('Range extensions', () {
    test("stepBy", () {
      List<int> collection = [];
      for (final x in (5, 10).stepBy(2)) {
        collection.add(x);
      }
      expect(collection, equals([5, 7, 9]));
    });
  });
}
