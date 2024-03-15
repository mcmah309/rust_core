// ignore_for_file: pattern_never_matches_value_type

import 'package:rust_core/option.dart';
import 'package:rust_core/result.dart';
import 'package:test/test.dart';

void main() {
  test("and", () {
    Option<int> x = Some(2);
    Option<String> y = None;
    expect(x.and(y), None);

    x = None;
    y = Some("foo");
    expect(x.and(y), None);

    x = Some(2);
    y = Some("foo");
    expect(x.and(y), Some("foo"));

    x = None;
    y = None;
    expect(x.and(y), None);
  });

  test("andThen", () {
    Result<String, String> sqThenToString(int x) {
      if (x > 10000) {
        return Err("overflowed");
      }
      return Ok<int, String>(x * x).map((s) => s.toString());
    }

    expect(Ok(2).andThen(sqThenToString), Ok(4.toString()));
    expect(Ok(1000000).andThen(sqThenToString), Err("overflowed"));
    expect(Err<int, String>("not a number").andThen(sqThenToString),
        Err("not a number"));
  });

  test("expect", () {
    final x = Ok(1);
    expect(x.expect("Error"), 1);

    final y = Err<String, String>("Failure");
    try {
      y.expect("Error occurred");
      fail("Should have thrown an error");
    } catch (e) {
      expect(e.toString(), contains("Error occurred"));
    }

    final some = Some(1);
    expect(some.expect("Error"), 1);

    final none = None;
    try {
      none.expect("Error occurred");
    } catch (e) {
      expect(e.toString(), contains("Error occurred"));
    }
  });

  test("filter", () {
    bool isEven(int n) => n % 2 == 0;

    Option<int> none = None;
    Option<int> some3 = Some(3);
    Option<int> some4 = Some(4);

    expect(none.filter(isEven), None);
    expect(some3.filter(isEven), None);
    expect(some4.filter(isEven), const Some(4));
    expect(None.filter((self) => false), None);
  });

  test("inspect", () {
    final x = Ok(1);
    int? y;
    x.inspect((e) {
      y = e;
    });
    expect(y, 1);
    // w.inspect((e) {
    //   y = e + 4;
    // });
    expect(y, 1);
    None.inspect((self) => null).and(Some(1));
  });

  test("isNone", () {
    Option<int> x = Some(2);
    expect(x.isNone(), false);

    Option<int> y = None;
    expect(y.isNone(), true);
  });

  test("isSome", () {
    Option<int> x = Some(2);
    expect(x.isSome(), true);

    Option<int> y = None;
    expect(y.isSome(), false);
  });

  test("isSomeAnd", () {
    Option<int> x = Some(2);
    expect(x.isSomeAnd((x) => x > 1), true);

    Option<int> y = Some(0);
    expect(y.isSomeAnd((y) => y > 1), false);

    Option<int> z = None;
    expect(z.isSomeAnd((z) => z > 1), false);
  });

  test("iterNext", () {
    Option<int> x = Some(4);
    var it = x.iter().iterator;
    it.moveNext();
    expect(it.current, 4);

    Option<int> y = None;
    it = y.iter().iterator;
    expect(it.moveNext(), false);
  });

  test("map", () {
    Option<String> maybeSomeString = Some("Hello, World!");
    Option<int> maybeSomeLen = maybeSomeString.map((s) => s.length);
    expect(maybeSomeLen, Some(13));

    Option<String> x = None;
    expect(x.map((s) => s.length), None);
  });

  test("mapOr", () {
    Option<String> x = Some("foo");
    expect(x.mapOr(42, (v) => v.length), 3);

    Option<String> y = None;
    expect(y.mapOr(42, (v) => v.length), 42);
  });

  test("mapOrElse", () {
    int k = 21;

    Option<String> x = Some("foo");
    expect(x.mapOrElse(() => 2 * k, (v) => v.length), 3);

    Option<String> y = None;
    expect(y.mapOrElse(() => 2 * k, (v) => v.length), 42);
  });

  test("okOr", () {
    Option<String> x = Some("foo");
    expect(x.okOr(0), Ok("foo"));

    Option<String> y = None;
    expect(y.okOr(0), Err(0));
  });

  test("okOrElse", () {
    Option<String> x = Some("foo");
    expect(x.okOrElse(() => 0), Ok("foo"));

    Option<String> y = None;
    expect(y.okOrElse(() => 0), Err(0));
  });

  test("or", () {
    Option<int> x = Some(2);
    Option<int> y = None;
    expect(x.or(y), Some(2));

    x = None;
    y = Some(100);
    expect(x.or(y), Some(100));

    x = Some(2);
    y = Some(100);
    expect(x.or(y), Some(2));

    x = None;
    y = None;
    expect(x.or(y), None);
  });

  Option<String> nobody() => None;
  Option<String> vikings() => Some("vikings");

  test("orElse", () {
    expect(Some("barbarians").orElse(vikings), Some("barbarians"));
    expect(None.orElse(vikings), Some("vikings"));
    expect(None.orElse(nobody), None);
  });

  test("unwrap", () {
    Option<String> x = Some("air");
    expect(x.unwrap(), "air");

    x = None;
    Object? w;
    try {
      x.unwrap();
    } catch (e) {
      w = e;
    }
    expect(w, isA<Error>());
  });

  test("unwrapOr", () {
    expect(Some("car").unwrapOr("bike"), "car");
    expect(None.unwrapOr("bike"), "bike");
  });

  test("unwrapOrElse", () {
    int k = 10;
    expect(Some(4).unwrapOrElse(() => 2 * k), 4);
    expect(None.unwrapOrElse(() => 2 * k), 20);
  });

  test("xor", () {
    Option<int> x = Some(2);
    Option<int> y = None;
    expect(x.xor(y), Some(2));

    x = None;
    y = Some(2);
    expect(x.xor(y), Some(2));

    x = Some(2);
    y = Some(2);
    expect(x.xor(y), None);

    x = None;
    y = None;
    expect(x.xor(y), None);
  });

  test("zip", () {
    Option<int> x = Some(1);
    Option<String> y = Some("hi");
    Option<int> z = None;

    expect(x.zip(y), Some((1, "hi")));
    expect(x.zip(z), None);
  });

  test("zipWith", () {
    Option<double> x = Some(17.5);
    Option<double> y = Some(42.7);
    Option<Point> nonePoint = None;

    expect(x.zipWith(y, (a, b) => Point(a, b)), Some(Point(17.5, 42.7)));
    expect(x.zipWith(nonePoint, (a, b) => Point(a, b.x)), None);
  });

  Option<int> int2Some() => Some(2);
  Option<int> intNone() => None;
  test("option switch", () {
    Option<int> x = int2Some();
    var y = switch (x) {
      Some(v: final s) => s,
      None => 4,
    };
    expect(y, 2);

    y = switch (x) {
      Some(v: final _) => 3,
      None => 4,
    };
    expect(y, 3);

    y = switch (x) {
      None => 4,
      Some(v: final _) => 3,
    };
    expect(y, 3);

    switch (x) {
      case Some(v: final _):
        int _ = 1;
      case None:
        fail('Should not reach here');
    }

    x = intNone();
    y = switch (x) {
      Some(v: final _) => 3,
      None => 4,
    };
    expect(y, 4);

    switch (x) {
      case Some(v: final _):
        fail('Should not reach here');
      case None:
        break;
    }

    Option<int> w = Some(1);
    int p;
    switch (w) {
      case Some(:final v):
        p = v;
      default:
        fail("Should not reach here");
    }
    int _ = p;

    // fails since: https://github.com/dart-lang/sdk/issues/55104
    // w = Some(1);
    // int u;
    // switch (w) {
    //   case Some(:final v):
    //     p = v;
    //   case None:
    //     fail("Should not reach here");
    // }
    // z = u;
  });

  test("Option and nullable conversions", () {
    Option<int> intNone() => None;
    Option<int> option = intNone();
    int? nullable = option.v;
    nullable = option.toNullable(); // or
    nullable = option as int?; // or
    option = Option.from(nullable);
    option = nullable as Option<int>; // or
  });

  group("Option Early Return", () {
    Option<int> int3Some() => Some(3);
    Option<int> intNone() => None;
    Option<double> double3Some() => Some(3);
    Option<double> doubleNone() => None;

    test('No Exit', () {
      Option<int> earlyReturn(int val) => Option(($) {
            int x = int3Some()[$];
            return Some(val + x);
          });
      expect(earlyReturn(2).unwrap(), 5);
    });

    test('With Exit', () {
      Option<int> earlyReturn(int val) => Option(($) {
            int x = intNone()[$];
            return Some(val + x);
          });
      expect(earlyReturn(2), None);
    });

    test('With different types None', () {
      Option<int> earlyReturn(int val) => Option(($) {
            double x = doubleNone()[$];
            return Some((val + x).toInt());
          });
      expect(earlyReturn(2), None);
    });

    test('With different types Some', () {
      Option<int> earlyReturn(int val) => Option(($) {
            double x = double3Some()[$];
            return Some((val + x).toInt());
          });
      expect(earlyReturn(2), Some(5));
    });

    test('Normal', () {
      Option<int> earlyReturn(int val) => Option(($) {
            double x = double3Some().unwrap();
            return Some((val + x).toInt());
          });
      expect(earlyReturn(2), Some(5));
    });
  });
}

class Point {
  final double x;
  final double y;

  Point(this.x, this.y);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Point && other.x == x && other.y == y;
  }

  @override
  int get hashCode => x.hashCode ^ y.hashCode;

  @override
  String toString() => 'Point { x: $x, y: $y }';
}
