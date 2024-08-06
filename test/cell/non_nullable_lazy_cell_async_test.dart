import 'package:rust_core/cell.dart';
import 'package:test/test.dart';

int callCount = 0;
Future<int> initFunc() async {
  callCount++;
  return 10;
}

Future<int?> initFuncNull() async {
  callCount++;
  return null;
}

void main() {

  group('NonNullableLazyCellAsync Tests', () {
    setUp(() {
      callCount = 0;
    });

    test('Value is lazily initialized', () async {
      var lazyCell = NonNullableLazyCellAsync<int>(initFunc);
      expect(callCount, equals(0));
      var value = await lazyCell.force();
      expect(value, equals(10));
      expect(callCount, equals(1));
    });

    test('Subsequent calls return the same value without reinitializing', () async {
      var lazyCell = NonNullableLazyCellAsync<int>(initFunc);
      var firstCall = await lazyCell.force();
      expect(callCount, equals(1));

      var secondCall = lazyCell();
      expect(secondCall, equals(firstCall));
      expect(callCount, equals(1));
    });

    test('Equality and hashCode', () async {
      var lazyCell1 = NonNullableLazyCellAsync<int>(initFunc);
      var lazyCell2 = NonNullableLazyCellAsync<int>(initFunc);

      expect(lazyCell1, equals(lazyCell2));
      expect(lazyCell2.hashCode, equals(lazyCell2.hashCode));
      await lazyCell2.force();
      expect(lazyCell1, isNot(equals(lazyCell2)));
      expect(lazyCell1.hashCode, isNot(equals(lazyCell2.hashCode)));
      await lazyCell1.force();
      expect(lazyCell1, equals(lazyCell2));
      expect(lazyCell2.hashCode, equals(lazyCell2.hashCode));
    });
  });

  test("LazyCell", () async {
    int callCount = 0;
    final lazyCell = LazyCellAsync<int>(() async {
      callCount++;
      return 20;
    });
    final firstCall = await lazyCell.force();
    expect(callCount, equals(1));
    expect(firstCall, equals(20));
    final secondCall = await lazyCell.force();
    expect(callCount, equals(1));
    expect(secondCall, equals(20));
  });
}