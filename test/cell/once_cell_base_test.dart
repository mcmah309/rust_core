import 'package:rust_core/cell.dart';
import 'package:test/test.dart';

void main() {
  group('NullableOnceCell Tests', () {
    NullableOnceCell<int> cell;

    test('Initial state', () {
      cell = NullableOnceCell<int>();
      expect(cell.getOrNull(), isNull);
    });

    test('Construction with initial value', () {
      var cellWithValue = NullableOnceCell.withValue(10);
      expect(cellWithValue.getOrNull(), equals(10));
    });

    test('getOrNull on non-empty cell', () {
      cell = NullableOnceCell<int>();
      cell.setOrNull(5);
      expect(cell.getOrNull(), equals(5));
    });

    test('getOrInit on empty cell', () {
      cell = NullableOnceCell<int>();
      var value = cell.getOrInit(() => 3);
      expect(value, equals(3));
    });

    test('getOrInit on non-empty cell', () {
      cell = NullableOnceCell<int>();
      cell.setOrNull(2);
      var value = cell.getOrInit(() => 3);
      expect(value, equals(2));
    });

    test('getOrTryInit on empty cell with success', () {
      cell = NullableOnceCell<int>();
      var result = cell.getOrTryInit(() => Ok(4));
      expect(result.unwrap(), equals(4));
    });

    test('getOrTryInit on empty cell with failure', () {
      cell = NullableOnceCell<int>();
      var result = cell.getOrTryInit(() => Err('Error'));
      expect(result.isErr(), isTrue);
    });

    test('getOrTryInit on non-empty cell', () {
      cell = NullableOnceCell<int>();
      cell.setOrNull(1);
      var result = cell.getOrTryInit(() => Ok(4));
      expect(result.unwrap(), equals(1));
    });

    test('setOrNull on empty cell', () {
      cell = NullableOnceCell<int>();
      var result = cell.setOrNull(6);
      expect(result, equals(6));
    });

    test('setOrNull on non-empty cell', () {
      cell = NullableOnceCell<int>();
      cell.setOrNull(7);
      var result = cell.setOrNull(8);
      expect(result, isNull);
    });

    test('takeOrNull on non-empty cell', () {
      cell = NullableOnceCell<int>();
      cell.setOrNull(9);
      var value = cell.takeOrNull();
      expect(value, equals(9));
      expect(cell.getOrNull(), isNull);
    });

    test('takeOrNull on empty cell', () {
      cell = NullableOnceCell<int>();
      var value = cell.takeOrNull();
      expect(value, isNull);
    });
  });
}
