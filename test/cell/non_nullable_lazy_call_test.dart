import 'package:rust_core/cell.dart';
import 'package:test/test.dart';

int callCount = 0;
int initFunc() {
  callCount++;
  return 10;
}

int? initFuncNull() {
  callCount++;
  return null;
}

void main() {

  group('NonNullableLazyCell Tests', () {
    setUp(() {
      callCount = 0;
    });

    test('Value is lazily initialized', () {
      var lazyCell = NonNullableLazyCell<int>(initFunc);
      expect(callCount, equals(0));
      var value = lazyCell();
      expect(value, equals(10));
      expect(callCount, equals(1));
    });

    test('Subsequent calls return the same value without reinitializing', () {
      var lazyCell = NonNullableLazyCell<int>(initFunc);
      var firstCall = lazyCell();
      expect(callCount, equals(1));

      var secondCall = lazyCell();
      expect(secondCall, equals(firstCall));
      expect(callCount, equals(1));
    });

    test('Equality and hashCode', () {
      var lazyCell1 = NonNullableLazyCell<int>(initFunc);
      var lazyCell2 = NonNullableLazyCell<int>(initFunc);

      expect(lazyCell1, equals(lazyCell2));
      expect(lazyCell2.hashCode, equals(lazyCell2.hashCode));
      lazyCell2();
      expect(lazyCell1, isNot(equals(lazyCell2)));
      expect(lazyCell1.hashCode, isNot(equals(lazyCell2.hashCode)));
      lazyCell1();
      expect(lazyCell1, equals(lazyCell2));
      expect(lazyCell2.hashCode, equals(lazyCell2.hashCode));
    });
  });

  test("LazyCell", () {
    int callCount = 0;
    final lazyCell = LazyCell<int>(() {
      callCount++;
      return 20;
    });
    final firstCall = lazyCell();
    expect(callCount, equals(1));
    expect(firstCall, equals(20));
    final secondCall = lazyCell();
    expect(callCount, equals(1));
    expect(secondCall, equals(20));
  });
}