import 'package:rust_core/cell.dart';
import 'package:rust_core/option.dart';
import 'package:rust_core/result.dart';
import 'package:test/test.dart';

void main() {

  group('NonNullableOnceCell Tests', () {
    NonNullableOnceCell<int> cell;

    test('Initial state', () {
      cell = NonNullableOnceCell<int>();
      expect(cell.get(), None);
    });

    test('Construction with initial value', () {
      var cellWithValue = NonNullableOnceCell.withValue(10);
      expect(cellWithValue.getOrNull(), equals(10));
    });

    test('getOrNull on non-empty cell', () {
      cell = NonNullableOnceCell<int>();
      cell.setOrNull(5);
      expect(cell.getOrNull(), equals(5));
    });

    test('getOrInit on empty cell', () {
      cell = NonNullableOnceCell<int>();
      var value = cell.getOrInit(() => 3);
      expect(value, equals(3));
    });

    test('getOrInit on non-empty cell', () {
      cell = NonNullableOnceCell<int>();
      cell.setOrNull(2);
      var value = cell.getOrInit(() => 3);
      expect(value, equals(2));
    });

    test('getOrTryInit on empty cell with success', () {
      cell = NonNullableOnceCell<int>();
      var result = cell.getOrTryInit(() => Ok(4));
      expect(result.unwrap(), equals(4));
    });

    test('getOrTryInit on empty cell with failure', () {
      cell = NonNullableOnceCell<int>();
      var result = cell.getOrTryInit(() => Err('Error'));
      expect(result.isErr(), isTrue);
    });

    test('getOrTryInit on non-empty cell', () {
      cell = NonNullableOnceCell<int>();
      cell.setOrNull(1);
      var result = cell.getOrTryInit(() => Ok(4));
      expect(result.unwrap(), equals(1));
    });

    test('setOrNull on empty cell', () {
      cell = NonNullableOnceCell<int>();
      var result = cell.setOrNull(6);
      expect(result, equals(6));
    });

    test('setOrNull on non-empty cell', () {
      cell = NonNullableOnceCell<int>();
      cell.setOrNull(7);
      var result = cell.setOrNull(8);
      expect(result, isNull);
    });

    test('set on empty cell', () {
      cell = NonNullableOnceCell<int>();
      var result = cell.set(10);
      expect(result, const Ok(()));
    });

    test('set on non-empty cell', () {
      cell = NonNullableOnceCell<int>();
      cell.set(11);
      var result = cell.set(12);
      expect(result.isErr(), isTrue);
    });

    test('takeOrNull on non-empty cell', () {
      cell = NonNullableOnceCell<int>();
      cell.setOrNull(9);
      var value = cell.takeOrNull();
      expect(value, equals(9));
      expect(cell.getOrNull(), isNull);
    });

    test('takeOrNull on empty cell', () {
      cell = NonNullableOnceCell<int>();
      var value = cell.takeOrNull();
      expect(value, isNull);
    });

    test('Equality and hashCode', () {
      var cell2 = NonNullableOnceCell<int>();
      cell = NonNullableOnceCell<int>();
      expect(cell, equals(cell2));
      expect(cell.hashCode, equals(cell2.hashCode));

      cell.setOrNull(13);
      expect(cell, isNot(equals(cell2)));
      expect(cell.hashCode, isNot(equals(cell2.hashCode)));
      cell2.setOrNull(13);
      expect(cell, equals(cell2));
      expect(cell.hashCode, equals(cell2.hashCode));
    });

    test("OnceCell", () {
      final cell = OnceCell<int>();
      var result = cell.set(10);
      expect(result, const Ok(()));
      result = cell.set(20);
      expect(result, const Err(20));
    });
  });
}
