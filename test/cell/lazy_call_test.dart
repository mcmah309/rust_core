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
  group('ConstNonNullableLazyCell Tests', () {
    setUp(() {
      callCount = 0;
    });

    test('Value is lazily initialized', () {
      var lazyCell = const ConstNonNullableLazyCell<int>(initFunc, 'id1');
      expect(callCount, equals(0));
      var value = lazyCell();
      expect(value, equals(10));
      expect(callCount, equals(1));
    });

    test('Subsequent calls return the same value without reinitializing', () {
      var lazyCell = const ConstNonNullableLazyCell<int>(initFunc, 'id2');
      var firstCall = lazyCell();
      expect(callCount, equals(1));

      var secondCall = lazyCell();
      expect(secondCall, equals(firstCall));
      expect(callCount, equals(1));
    });

    test('Different instances with the same id have the same value', () {
      var lazyCell1 = const ConstNonNullableLazyCell<int>(initFunc, 'id3');
      var lazyCell2 = const ConstNonNullableLazyCell<int>(initFunc, 'id3');

      lazyCell1();
      expect(callCount, equals(1));
      expect(lazyCell2(), equals(10));
      expect(callCount, equals(1));
    });

    test('Different instances with different ids have different values', () {
      var lazyCell1 = const ConstNonNullableLazyCell<int>(initFunc, 'id4');
      var lazyCell2 = const ConstNonNullableLazyCell<int>(initFunc, 'id5');

      lazyCell1();
      expect(callCount, equals(1));
      lazyCell2();
      expect(callCount, equals(2));
    });

    test('Equality and hashCode', () {
      var lazyCell1 = const ConstNonNullableLazyCell<int>(initFunc, 'id6');
      var lazyCell2 = const ConstNonNullableLazyCell<int>(initFunc, 'id7');
      var lazyCell1SameId =
          const ConstNonNullableLazyCell<int>(initFunc, 'id6');

      expect(lazyCell1, equals(lazyCell2));
      expect(lazyCell1.hashCode, equals(lazyCell2.hashCode));
      lazyCell2();
      expect(lazyCell1, isNot(equals(lazyCell2)));
      expect(lazyCell1.hashCode, isNot(equals(lazyCell2.hashCode)));
      expect(lazyCell1, equals(lazyCell1SameId));
      expect(lazyCell1.hashCode, equals(lazyCell1SameId.hashCode));
      lazyCell1();
      expect(lazyCell1, equals(lazyCell2));
      expect(lazyCell2.hashCode, equals(lazyCell2.hashCode));
    });
  });

  group('ConstNullableLazyCell Tests', () {
    setUp(() {
      callCount = 0;
    });

    test('Value is lazily initialized', () {
      var lazyCell = const ConstNullableLazyCell<int?>(initFunc, 'id1');
      expect(callCount, equals(0));
      var value = lazyCell();
      expect(value, equals(10));
      expect(callCount, equals(1));
    });

    test('Subsequent calls return the same value without reinitializing', () {
      var lazyCell = const ConstNullableLazyCell<int?>(initFunc, 'id2');
      var firstCall = lazyCell();
      expect(callCount, equals(1));

      var secondCall = lazyCell();
      expect(secondCall, equals(firstCall));
      expect(callCount, equals(1));
    });

    test('Value can be null', () {
      var nullLazyCell = const ConstNullableLazyCell<int?>(initFuncNull, 'id3');
      expect(callCount, equals(0));
      expect(nullLazyCell(), isNull);
      expect(callCount, equals(1));
    });

    test('Different instances with the same id have the same value', () {
      var lazyCell1 = const ConstNullableLazyCell<int?>(initFunc, 'id4');
      var lazyCell2 = const ConstNullableLazyCell<int?>(initFunc, 'id4');

      lazyCell1();
      expect(callCount, equals(1));
      expect(lazyCell2(), equals(10));
      expect(callCount, equals(1));
    });

    test('Different instances with different ids have different values', () {
      var lazyCell1 = const ConstNullableLazyCell<int?>(initFunc, 'id5');
      var lazyCell2 = const ConstNullableLazyCell<int?>(initFunc, 'id6');

      lazyCell1();
      expect(callCount, equals(1));
      lazyCell2();
      expect(callCount, equals(2));
    });

    test('Equality and hashCode', () {
      var lazyCell1 = const ConstNullableLazyCell<int?>(initFunc, 'id7');
      var lazyCell2 = const ConstNullableLazyCell<int?>(initFunc, 'id8');
      var lazyCell1SameId = const ConstNullableLazyCell<int?>(initFunc, 'id7');

      expect(lazyCell1, equals(lazyCell2));
      expect(lazyCell1.hashCode, equals(lazyCell2.hashCode));
      lazyCell2();
      expect(lazyCell1, isNot(equals(lazyCell2)));
      expect(lazyCell1.hashCode, isNot(equals(lazyCell2.hashCode)));
      expect(lazyCell1, equals(lazyCell1SameId));
      expect(lazyCell1.hashCode, equals(lazyCell1SameId.hashCode));
      lazyCell1();
      expect(lazyCell1, equals(lazyCell2));
      expect(lazyCell2.hashCode, equals(lazyCell2.hashCode));
    });
  });

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

  test("LazyCell",(){
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

  test("LazyCell Equality",(){
    final nullableLazyCell = NullableLazyCell<int>(() {
      return 20;
    });
    final constNonNullableLazyCell = ConstNonNullableLazyCell<int>(() {
      return 20;
    }, "dfasdfas");
    expect(nullableLazyCell, equals(constNonNullableLazyCell));
    nullableLazyCell();
    expect(nullableLazyCell, isNot(equals(constNonNullableLazyCell)));
    constNonNullableLazyCell();
    expect(nullableLazyCell, equals(constNonNullableLazyCell));
  });
}
