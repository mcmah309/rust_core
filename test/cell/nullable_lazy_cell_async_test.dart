import 'package:rust_core/cell.dart';
import 'package:test/test.dart';

void main() {
  group('NullableLazyCellAsync Tests', () {
    NullableLazyCellAsync<int?> lazyCell;
    int callCount = 0;
    initFunc() async {
      callCount++;
      return 10;
    }

    setUp(() {
      callCount = 0;
    });

    test('Value is lazily initialized', () async {
      lazyCell = NullableLazyCellAsync<int?>(initFunc);
      expect(callCount, equals(0));
      var value = await lazyCell.force();
      expect(value, equals(10));
      expect(callCount, equals(1));
    });

    test('Subsequent calls return the same value without reinitializing', () async {
      lazyCell = NullableLazyCellAsync<int?>(initFunc);
      var firstCall = await lazyCell.force();
      expect(callCount, equals(1));

      var secondCall = await lazyCell.force();
      expect(secondCall, equals(firstCall));
      expect(callCount, equals(1));
    });

    test('Works with null values', () async {
      var nullLazyCell = NullableLazyCellAsync<int?>(() async => null);
      expect(await nullLazyCell.force(), isNull);
    });

    test('Equality and hashCode', () async {
      lazyCell = NullableLazyCellAsync<int?>(initFunc);
      var anotherLazyCell = NullableLazyCellAsync<int?>(initFunc);
      await anotherLazyCell.force();

      expect(lazyCell, isNot(equals(anotherLazyCell)));
      expect(lazyCell.hashCode, isNot(equals(anotherLazyCell.hashCode)));

      await lazyCell.force();
      expect(lazyCell, equals(anotherLazyCell));
      expect(lazyCell.hashCode, equals(anotherLazyCell.hashCode));
    });
  });
}
