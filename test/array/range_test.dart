import 'package:rust_core/array.dart';
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

  group('rangeArr', () {
    test('Ascending', () {
      expect(rangeArr(5, 10), equals([5, 6, 7, 8, 9]));
      expect(rangeArr(5, 10, step: 2), equals([5, 7, 9]));
      expect(rangeArr(5, 10, step: 10), equals([5]));
      expect(() => rangeArr(5, 10, step: 0), throwsA(isA<AssertionError>()));
    });

    test('Descending', () {
      expect(rangeArr(10, 5), equals([10, 9, 8, 7, 6]));
      expect(rangeArr(10, 5, step: 2), equals([10, 8, 6]));
      expect(rangeArr(10, 5, step: 10), equals([10]));
      expect(() => rangeArr(10, 5, step: 0), throwsA(isA<AssertionError>()));
    });

    test('Same', () {
      expect(rangeArr(5, 5), equals([]));
      expect(rangeArr(5, 5, step: 10), equals([]));
      expect(() => rangeArr(5, 5, step: 0), throwsA(isA<AssertionError>()));
    });
  });
}
