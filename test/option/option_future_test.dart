import 'dart:async';
import 'package:rust_core/option.dart';
import 'package:rust_core/result.dart';
import 'package:test/test.dart';

void main() {
  group('FutureOptionExtension Tests', () {
    test("and", () async {
      FutureOption<int> x = Future.value(Some(2));
      Option<int> y = const None();
      expect(await x.and(y), const None());

      x = Future.value(const None());
      y = Some(100);
      expect(await x.and(y), const None());
    });

    test("andThen", () async {
      FutureOr<Option<int>> square(int x) async {
        return Some(x * x);
      }

      FutureOption<int> x = Future.value(Some(2));
      expect(await x.andThen(square), Some(4));

      x = Future.value(const None());
      expect(await x.andThen(square), const None());
    });

    test("expect", () async {
      FutureOption<int> x = Future.value(Some(1));
      expect(await x.expect("Error"), 1);

      x = Future.value(const None());
      expect(
          () async => await x.expect("Error occurred"), throwsA(isA<Error>()));
    });

    test("filter", () async {
      Future<bool> isEven(int n) async => n % 2 == 0;

      FutureOption<int> x = Future.value(const None());
      expect(await x.filter(isEven), const None());

      x = Future.value(Some(4));
      expect(await x.filter(isEven), Some(4));
    });

    test("inspect", () async {
      FutureOption<int> x = Future.value(Some(1));
      int? result;
      await x.inspect((value) => result = value);
      expect(result, 1);

      FutureOption<int> y = Future.value(const None());
      await y.inspect((value) => result = value + 1);
      expect(result, 1); // No change should occur as it's None
    });

    test("isNone", () async {
      FutureOption<int> x = Future.value(Some(2));
      expect(await x.isNone(), false);

      x = Future.value(const None());
      expect(await x.isNone(), true);
    });

    test("isSome", () async {
      FutureOption<int> x = Future.value(Some(2));
      expect(await x.isSome(), true);

      x = Future.value(const None());
      expect(await x.isSome(), false);
    });

    test("isSomeAnd", () async {
      FutureOption<int> x = Future.value(Some(2));
      expect(await x.isSomeAnd((value) => value > 1), true);

      x = Future.value(Some(0));
      expect(await x.isSomeAnd((value) => value > 1), false);

      x = Future.value(const None());
      expect(await x.isSomeAnd((value) => value > 1), false);
    });

    test("iter", () async {
      FutureOption<int> x = Future.value(Some(4));
      Iterable<int> iterable = await x.iter();
      expect(iterable, contains(4));

      x = Future.value(const None());
      iterable = await x.iter();
      expect(iterable, isEmpty);
    });

    test("map", () async {
      FutureOption<String> x = Future.value(Some("hello"));
      expect(await x.map((v) => v.length), Some(5));

      x = Future.value(const None());
      expect(await x.map((v) => v.length), const None());
    });

    test("mapOr", () async {
      FutureOption<String> x = Future.value(Some("hello"));
      expect(await x.mapOr(0, (v) => v.length), 5);

      x = Future.value(const None());
      expect(await x.mapOr(0, (v) => v.length), 0);
    });

    test("mapOrElse", () async {
      FutureOption<String> x = Future.value(Some("hello"));
      expect(await x.mapOrElse(() => 0, (v) => v.length), 5);

      x = Future.value(const None());
      expect(await x.mapOrElse(() => 0, (v) => v.length), 0);
    });

    test("okOr", () async {
      FutureOption<String> x = Future.value(Some("foo"));
      expect(await x.okOr(0), Ok("foo"));

      x = Future.value(const None());
      expect(await x.okOr(0), Err(0));
    });

    test("okOrElse", () async {
      FutureOption<String> x = Future.value(Some("foo"));
      expect(await x.okOrElse(() => 0), Ok("foo"));

      x = Future.value(const None());
      expect(await x.okOrElse(() => 0), Err(0));
    });

    test("or", () async {
      FutureOption<int> x = Future.value(Some(2));
      Option<int> y = const None();
      expect(await x.or(y), Some(2));

      x = Future.value(const None());
      y = Some(100);
      expect(await x.or(y), Some(100));
    });

    test("orElse", () async {
      FutureOption<String> x = Future.value(Some("barbarians"));
      expect(await x.orElse(() => Some("vikings")), Some("barbarians"));

      x = Future.value(const None());
      expect(await x.orElse(() => Some("vikings")), Some("vikings"));
    });

    test("unwrap", () async {
      FutureOption<String> x = Future.value(Some("air"));
      expect(await x.unwrap(), "air");

      x = Future.value(const None());
      expect(() async => await x.unwrap(), throwsA(isA<Error>()));
    });

    test("unwrapOr", () async {
      FutureOption<String> x = Future.value(Some("car"));
      expect(await x.unwrapOr("bike"), "car");

      x = Future.value(const None());
      expect(await x.unwrapOr("bike"), "bike");
    });

    test("unwrapOrElse", () async {
      FutureOption<int> x = Future.value(Some(4));
      expect(await x.unwrapOrElse(() => 10), 4);

      x = Future.value(const None());
      expect(await x.unwrapOrElse(() => 10), 10);
    });

    test("xor", () async {
      FutureOption<int> x = Future.value(Some(2));
      Option<int> y = const None();
      expect(await x.xor(y), Some(2));

      x = Future.value(const None());
      y = Some(2);
      expect(await x.xor(y), Some(2));
    });

    test("zip", () async {
      FutureOption<int> x = Future.value(Some(1));
      Option<String> y = Some("hi");
      expect(await x.zip(y), Some((1, "hi")));

      y = const None();
      expect(await x.zip(y), const None());
    });

    test("zipWith", () async {
      FutureOption<double> x = Future.value(Some(17.5));
      Option<double> y = Some(42.7);
      expect(await x.zipWith(y, (a, b) => a + b), Some(60.2));

      y = const None();
      expect(await x.zipWith(y, (a, b) => a + b), const None());
    });

    test("toNullable", () async {
      FutureOption<int> x = Future.value(Some(1));
      expect(await x.toNullable(), 1);

      x = Future.value(const None());
      expect(await x.toNullable(), null);
    });
  });
}
