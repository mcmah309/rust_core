import 'package:rust_core/cell.dart';
import 'package:rust_core/option.dart';
import 'package:rust_core/result.dart';
import 'package:test/test.dart';

void main() {
  group('ConstNullableOnceCell Tests', () {
    ConstNullableOnceCell<int> cell;

    test('Initial state', () {
      cell = const ConstNullableOnceCell<int>(1);
      expect(cell.getOrNull(), isNull);
    });

    test('getOrNull on non-empty cell', () {
      cell = const ConstNullableOnceCell<int>(2);
      cell.setOrNull(5);
      expect(cell.getOrNull(), equals(5));
    });

    test('getOrInit on empty cell', () {
      cell = const ConstNullableOnceCell<int>(3);
      var value = cell.getOrInit(() => 3);
      expect(value, equals(3));
    });

    test('getOrInit on non-empty cell', () {
      cell = const ConstNullableOnceCell<int>(4);
      cell.setOrNull(2);
      var value = cell.getOrInit(() => 3);
      expect(value, equals(2));
    });

    test('getOrTryInit on empty cell with success', () {
      cell = const ConstNullableOnceCell<int>(5);
      var result = cell.getOrTryInit(() => Ok(4));
      expect(result.unwrap(), equals(4));
    });

    test('getOrTryInit on empty cell with failure', () {
      cell = const ConstNullableOnceCell<int>(6);
      var result = cell.getOrTryInit(() => Err('Error'));
      expect(result.isErr(), isTrue);
    });

    test('getOrTryInit on non-empty cell', () {
      cell = const ConstNullableOnceCell<int>(7);
      cell.setOrNull(1);
      var result = cell.getOrTryInit(() => Ok(4));
      expect(result.unwrap(), equals(1));
    });

    test('setOrNull on empty cell', () {
      cell = const ConstNullableOnceCell<int>(8);
      var result = cell.setOrNull(6);
      expect(result, equals(6));
    });

    test('setOrNull on non-empty cell', () {
      cell = const ConstNullableOnceCell<int>(9);
      cell.setOrNull(7);
      var result = cell.setOrNull(8);
      expect(result, isNull);
    });

    test('takeOrNull on non-empty cell', () {
      cell = const ConstNullableOnceCell<int>(10);
      cell.setOrNull(9);
      var value = cell.takeOrNull();
      expect(value, equals(9));
      expect(cell.getOrNull(), isNull);
    });

    test('takeOrNull on empty cell', () {
      cell = const ConstNullableOnceCell<int>(11);
      var value = cell.takeOrNull();
      expect(value, isNull);
    });

    test('Equality and hashCode', () {
      cell = const ConstNullableOnceCell<int>(12);
      var anotherCell = const ConstNullableOnceCell<int>(13);

      expect(cell, equals(anotherCell));
      expect(cell.hashCode, equals(anotherCell.hashCode));
      anotherCell.setOrNull(1);
      expect(cell, isNot(equals(anotherCell)));
      expect(cell.hashCode, isNot(equals(anotherCell.hashCode)));
      cell.setOrNull(1);
      expect(cell, equals(anotherCell));
      expect(cell.hashCode, equals(anotherCell.hashCode));
    });
  });

  group('ConstNullableOnceCell Tests for int?', () {
    ConstNullableOnceCell<int?> cell;

    test('Initial state', () {
      cell = const ConstNullableOnceCell<int?>(1);
      expect(cell.getOrNull(), isNull);
    });

    test('getOrNull on non-empty cell', () {
      cell = const ConstNullableOnceCell<int?>(2);
      cell.setOrNull(5);
      expect(cell.getOrNull(), equals(5));
    });

    test('getOrInit on empty cell', () {
      cell = const ConstNullableOnceCell<int?>(3);
      var value = cell.getOrInit(() => 3);
      expect(value, equals(3));
    });

    test('getOrInit on non-empty cell', () {
      cell = const ConstNullableOnceCell<int?>(4);
      cell.setOrNull(2);
      var value = cell.getOrInit(() => 3);
      expect(value, equals(2));
    });

    test('getOrTryInit on empty cell with success', () {
      cell = const ConstNullableOnceCell<int?>(5);
      var result = cell.getOrTryInit(() => Ok(4));
      expect(result.unwrap(), equals(4));
    });

    test('getOrTryInit on empty cell with failure', () {
      cell = const ConstNullableOnceCell<int?>(6);
      var result = cell.getOrTryInit(() => Err('Error'));
      expect(result.isErr(), isTrue);
    });

    test('getOrTryInit on non-empty cell', () {
      cell = const ConstNullableOnceCell<int?>(7);
      cell.setOrNull(1);
      var result = cell.getOrTryInit(() => Ok(4));
      expect(result.unwrap(), equals(1));
    });

    test('setOrNull on empty cell', () {
      cell = const ConstNullableOnceCell<int?>(8);
      var result = cell.setOrNull(6);
      expect(result, equals(6));
    });

    test('setOrNull on non-empty cell', () {
      cell = const ConstNullableOnceCell<int?>(9);
      cell.setOrNull(7);
      var result = cell.setOrNull(8);
      expect(result, isNull);
    });

    test('takeOrNull on non-empty cell', () {
      cell = const ConstNullableOnceCell<int?>(10);
      cell.setOrNull(9);
      var value = cell.takeOrNull();
      expect(value, equals(9));
      expect(cell.getOrNull(), isNull);
    });

    test('takeOrNull on empty cell', () {
      cell = const ConstNullableOnceCell<int?>(11);
      var value = cell.takeOrNull();
      expect(value, isNull);
    });
  });

  group('ConstNullableOnceCell Tests with null input', () {
    ConstNullableOnceCell<int?> cell;

    test('Initial state', () {
      cell = const ConstNullableOnceCell<int?>(12);
      expect(cell.getOrNull(), isNull);
    });

    test('setOrNull with null on empty cell', () {
      cell = const ConstNullableOnceCell<int?>(13);
      var result = cell.setOrNull(null);
      expect(result, isNull);
    });

    test('getOrNull returns null when set with null', () {
      cell = const ConstNullableOnceCell<int?>(14);
      cell.setOrNull(null);
      expect(cell.getOrNull(), isNull);
    });

    test('getOrInit does not change null value', () {
      cell = const ConstNullableOnceCell<int?>(15);
      cell.setOrNull(null);
      var value = cell.getOrInit(() => 3);
      expect(value, isNull);
    });

    test('getOrTryInit on cell set with null returns null', () {
      cell = const ConstNullableOnceCell<int?>(16);
      cell.setOrNull(null);
      var result = cell.getOrTryInit(() => Ok(4));
      expect(result.unwrap(), isNull);
    });

    test('takeOrNull on cell set with null returns null and empties cell', () {
      cell = const ConstNullableOnceCell<int?>(17);
      cell.setOrNull(null);
      var value = cell.takeOrNull();
      expect(value, isNull);
      expect(cell.getOrNull(), isNull);
    });
  });

  group('ConstNonNullableOnceCell Tests', () {
    ConstNonNullableOnceCell<int> cell;

    test('Initial state', () {
      cell = const ConstNonNullableOnceCell<int>(1);
      expect(cell.getOrNull(), isNull);
    });

    test('getOrNull on non-empty cell', () {
      cell = const ConstNonNullableOnceCell<int>(2);
      cell.setOrNull(5);
      expect(cell.getOrNull(), equals(5));
    });

    test('getOrInit on empty cell', () {
      cell = const ConstNonNullableOnceCell<int>(3);
      var value = cell.getOrInit(() => 3);
      expect(value, equals(3));
    });

    test('getOrInit on non-empty cell', () {
      cell = const ConstNonNullableOnceCell<int>(4);
      cell.setOrNull(2);
      var value = cell.getOrInit(() => 3);
      expect(value, equals(2));
    });

    test('getOrTryInit on empty cell with success', () {
      cell = const ConstNonNullableOnceCell<int>(5);
      var result = cell.getOrTryInit(() => Ok(4));
      expect(result.unwrap(), equals(4));
    });

    test('getOrTryInit on empty cell with failure', () {
      cell = const ConstNonNullableOnceCell<int>(6);
      var result = cell.getOrTryInit(() => Err('Error'));
      expect(result.isErr(), isTrue);
    });

    test('getOrTryInit on non-empty cell', () {
      cell = const ConstNonNullableOnceCell<int>(7);
      cell.setOrNull(1);
      var result = cell.getOrTryInit(() => Ok(4));
      expect(result.unwrap(), equals(1));
    });

    test('setOrNull on empty cell', () {
      cell = const ConstNonNullableOnceCell<int>(8);
      var result = cell.setOrNull(6);
      expect(result, equals(6));
    });

    test('setOrNull on non-empty cell', () {
      cell = const ConstNonNullableOnceCell<int>(9);
      cell.setOrNull(7);
      var result = cell.setOrNull(8);
      expect(result, isNull);
    });

    test('takeOrNull on non-empty cell', () {
      cell = const ConstNonNullableOnceCell<int>(10);
      cell.setOrNull(9);
      var value = cell.takeOrNull();
      expect(value, equals(9));
      expect(cell.getOrNull(), isNull);
    });

    test('takeOrNull on empty cell', () {
      cell = const ConstNonNullableOnceCell<int>(11);
      var value = cell.takeOrNull();
      expect(value, isNull);
    });

    test('Equality and hashCode', () {
      cell = const ConstNonNullableOnceCell<int>(12);
      var anotherCell = const ConstNonNullableOnceCell<int>(13);

      expect(cell, equals(anotherCell));
      expect(cell.hashCode, equals(anotherCell.hashCode));
      anotherCell.set(1);
      expect(cell, isNot(equals(anotherCell)));
      expect(cell.hashCode, isNot(equals(anotherCell.hashCode)));
      cell.set(1);
      expect(cell, equals(anotherCell));
      expect(cell.hashCode, equals(anotherCell.hashCode));
    });
  });

  group('NonNullableOnceCell Tests', () {
    NonNullableOnceCell<int> cell;

    test('Initial state', () {
      cell = NonNullableOnceCell<int>();
      expect(cell.get(), const None());
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
  });
}
