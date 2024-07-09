import 'package:rust_core/ops.dart';
import 'package:rust_core/panic.dart';
import 'package:rust_core/array.dart';
import 'package:test/test.dart';

void main() {
  group('Range', () {
    test('Range and HalfOpenRange', () {
      expect(HalfOpenRange(5, 10).toList(), equals([5, 6, 7, 8, 9]));
      expect(HalfOpenRange(10, 5).toList(), equals([10, 9, 8, 7, 6]));
      expect(HalfOpenRange(5, 5).toList(), equals([]));

      var arr = Arr.range(0, 10);
      expect(arr(HalfOpenRange(5, 10)).toList(), [5, 6, 7, 8, 9]);
      expect(arr(HalfOpenRange(9, 4)).toList(), [9, 8, 7, 6, 5]);

      expect(() => arr(HalfOpenRange(-1, 4)), throwsA(isA<Panic>()));

      var slice = arr.slice(1,9);
      expect(slice(HalfOpenRange(5, 8)).toList(), [6, 7, 8]);
      expect(slice(HalfOpenRange(8, 5)).toList(), [9, 8, 7]);

      expect(() => slice(HalfOpenRange(-1, 4)), throwsA(isA<Panic>()));


      expect(Range(5, 10).toList(), equals([5, 6, 7, 8, 9]));
      expect(Range(10, 5).toList(), equals([10, 9, 8, 7, 6]));
      expect(Range(5, 5).toList(), equals([]));

      expect(arr(Range(5, 10)).toList(), [5, 6, 7, 8, 9]);
      expect(arr(Range(9, 4)).toList(), [9, 8, 7, 6, 5]);

      expect(() => arr(Range(-1, 4)), throwsA(isA<Panic>()));

      expect(slice(Range(5, 8)).toList(), [6, 7, 8]);
      expect(slice(Range(8, 5)).toList(), [9, 8, 7]);

      expect(() => slice(Range(-1, 4)), throwsA(isA<Panic>()));
    });

    test('RangeFrom', () {
      expect(RangeFrom(5).take(5).toList(), equals([5, 6, 7, 8, 9]));
      expect(RangeFrom(-2).take(5).toList(), equals([-2, -1, 0, 1, 2]));

      var arr = Arr.range(0, 10);
      expect(arr(RangeFrom(5)).take(5).toList(), [5, 6, 7, 8, 9]);
      expect(() => arr(RangeFrom(-1)).take(5).toList(), throwsA(isA<Panic>()));

      var slice = arr.slice(1,9);
      expect(slice(RangeFrom(5)).take(3).toList(), [6, 7, 8]);
      expect(() => slice(RangeFrom(-1)).take(5).toList(), throwsA(isA<Panic>()));
    });
  });
}
