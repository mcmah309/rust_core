import 'package:rust_core/array.dart';
import 'package:test/test.dart';

void main() {
  group('Arr.range', () {
    test('Ascending', () {
      expect(Arr.range(5, 10), equals([5, 6, 7, 8, 9]));
      expect(Arr.range(5, 10, step: 2), equals([5, 7, 9]));
      expect(Arr.range(5, 10, step: 10), equals([5]));
      expect(() => Arr.range(5, 10, step: 0), throwsA(isA<AssertionError>()));
    });

    test('Descending', () {
      expect(Arr.range(10, 5), equals([10, 9, 8, 7, 6]));
      expect(Arr.range(10, 5, step: 2), equals([10, 8, 6]));
      expect(Arr.range(10, 5, step: 10), equals([10]));
      expect(() => Arr.range(10, 5, step: 0), throwsA(isA<AssertionError>()));
    });

    test('Same', () {
      expect(Arr.range(5, 5), equals([]));
      expect(Arr.range(5, 5, step: 10), equals([]));
      expect(() => Arr.range(5, 5, step: 0), throwsA(isA<AssertionError>()));
    });
  });
}
