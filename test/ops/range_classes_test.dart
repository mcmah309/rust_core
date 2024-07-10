import 'package:rust_core/ops.dart';
import 'package:rust_core/panic.dart';
import 'package:rust_core/array.dart';
import 'package:rust_core/slice.dart';
import 'package:test/test.dart';

void main() {
  group('RangeBounds', () {
    test('Range', () {
      var arr = Arr.range(0, 10);
      var slice = arr.slice(1, 9);

      expect(Range(5, 10).toList(), equals([5, 6, 7, 8, 9]));
      expect(Range(10, 5).toList(), equals([]));
      expect(Range(5, 5).toList(), equals([]));

      expect(arr(Range(5, 10)).toList(), [5, 6, 7, 8, 9]);
      expect(() => arr(Range(9, 4)).toList(), throwsA(isA<Panic>()));

      expect(() => arr(Range(-1, 4)).toList(), throwsA(isA<Panic>()));
      expect(() => arr(Range(3, 1)).toList(), throwsA(isA<Panic>()));

      expect(slice(Range(5, 8)).toList(), [6, 7, 8]);
      expect(() => slice(Range(8, 5)).toList(), throwsA(isA<Panic>()));

      expect(() => slice(Range(-1, 4)).toList(), throwsA(isA<Panic>()));
      expect(() => slice(Range(3, 1)).toList(), throwsA(isA<Panic>()));
    });

    test('RangeFrom', () {
      expect(RangeFrom(5).take(5).toList(), equals([5, 6, 7, 8, 9]));
      expect(RangeFrom(-2).take(5).toList(), equals([-2, -1, 0, 1, 2]));

      var arr = Arr.range(0, 10);
      expect(arr(RangeFrom(5)).take(5).toList(), [5, 6, 7, 8, 9]);
      expect(() => arr(RangeFrom(-1)).take(5).toList(), throwsA(isA<Panic>()));

      var slice = arr.slice(1, 9);
      expect(slice(RangeFrom(5)).take(3).toList(), [6, 7, 8]);
      expect(
          () => slice(RangeFrom(-1)).take(5).toList(), throwsA(isA<Panic>()));
    });

    test('RangeFull', () {
      var arr = Arr.range(0, 10);
      expect(arr(RangeFull()).toList(), [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);

      var slice = arr.slice(1, 9);
      expect(slice(RangeFull()).toList(), [1, 2, 3, 4, 5, 6, 7, 8]);
    });

    test('RangeInclusive', () {
      expect(RangeInclusive(5, 9).toList(), equals([5, 6, 7, 8, 9]));
      expect(RangeInclusive(10, 5).toList(), equals([]));
      expect(RangeInclusive(5, 5).toList(), equals([5]));

      var arr = Arr.range(0, 10);
      expect(arr(RangeInclusive(5, 9)).toList(), [5, 6, 7, 8, 9]);
      expect(() => arr(RangeInclusive(9, 4)).toList(), throwsA(isA<Panic>()));

      expect(() => arr(RangeInclusive(-1, 4)).toList(), throwsA(isA<Panic>()));
      expect(() => arr(RangeInclusive(3, 1)).toList(), throwsA(isA<Panic>()));
      expect(() => arr(RangeInclusive(0, -1)).toList(),
          throwsA(isA<AssertionError>()));

      var slice = arr.slice(1, 9);
      expect(slice(RangeInclusive(5, 7)).toList(), [6, 7, 8]);
      expect(() => slice(RangeInclusive(8, 5)).toList(), throwsA(isA<Panic>()));

      expect(
          () => slice(RangeInclusive(-1, 4)).toList(), throwsA(isA<Panic>()));
      expect(() => slice(RangeInclusive(3, 1)).toList(), throwsA(isA<Panic>()));
      expect(() => slice(RangeInclusive(0, -1)).toList(),
          throwsA(isA<AssertionError>()));
    });

    test('RangeTo', () {
      var arr = Arr.range(0, 10);
      expect(arr(RangeTo(5)).toList(), [0, 1, 2, 3, 4]);
      expect(() => arr(RangeTo(-1)).toList(), throwsA(isA<Panic>()));
      expect(() => arr(RangeTo(11)).toList(), throwsA(isA<Panic>()));

      var slice = arr.slice(1, 9);
      expect(slice(RangeTo(5)).toList(), [1, 2, 3, 4, 5]);
      expect(() => slice(RangeTo(10)).toList(), throwsA(isA<Panic>()));
      expect(() => slice(RangeTo(-1)).toList(), throwsA(isA<Panic>()));
    });

    test('RangeToInclusive', () {
      var arr = Arr.range(0, 10);
      expect(arr(RangeToInclusive(5)).toList(), [0, 1, 2, 3, 4, 5]);
      expect(() => arr(RangeToInclusive(-1)).toList(),
          throwsA(isA<AssertionError>()));
      expect(() => arr(RangeToInclusive(11)).toList(), throwsA(isA<Panic>()));

      var slice = arr.slice(1, 9);
      expect(slice(RangeToInclusive(5)).toList(), [1, 2, 3, 4, 5, 6]);
      expect(() => slice(RangeToInclusive(10)).toList(), throwsA(isA<Panic>()));
      expect(() => slice(RangeToInclusive(-1)).toList(),
          throwsA(isA<AssertionError>()));
    });

    test('Range Bounds example', () {
      void func(RangeBounds bounds) {
        Arr<int> arr = Arr.range(0, 10);
        Slice<int> slice = arr(bounds);
        expect(slice, equals([4, 5, 6, 7, 8, 9]));
      }

      func(const RangeFrom(4));

      for (int x in const Range(5, 10)) {
        // code
      }
    });
  });
}
