

import 'package:rust_core/array.dart';
import 'package:test/test.dart';


void main() {
  group('range', () {
    test('Default range with inclusive start and exclusive end', () {
      expect(range(5, 10), equals([5, 6, 7, 8, 9]));
    });

    test('Range with exclusive start and exclusive end', () {
      expect(range(5, 10, sInc: false), equals([6, 7, 8, 9]));
    });

    test('Range with inclusive start and inclusive end', () {
      expect(range(5, 10, eInc: true), equals([5, 6, 7, 8, 9, 10]));
    });

    test('Range with exclusive start and inclusive end', () {
      expect(range(5, 10, sInc: false, eInc: true), equals([6, 7, 8, 9, 10]));
    });

    test('Range with same start and end, inclusive start and end', () {
      expect(range(5, 5, eInc: true), equals([5]));
    });

    test('Invalid range with start greater than end', () {
      expect(() => range(10, 5), throwsA(isA<RangeError>()));
    });

    test('Range with same start and end, exclusive start', () {
      expect(() => range(5, 5, sInc: false), throwsA(isA<RangeError>()));
    });

    test('Range with same start and end, exclusive end', () {
      expect(range(5, 5, eInc: false), equals([]));
    });
  });
}