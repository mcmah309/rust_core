import 'package:rust_core/option.dart';
import 'package:rust_core/result.dart';
import 'package:test/test.dart';

void main(){
  test("and",(){
    Result<int, String> x = Ok(2);
    Result<String,String> y = Err("late error");
    expect(x.and(y), Err("late error"));

    x = Err("early error");
    y = Ok("foo");
    expect(x.and(y), Err("early error"));

    x = Err("not a 2");
    y = Err("late error");
    expect(x.and(y), Err("not a 2"));

    x = Ok(2);
    y = Ok("different result type");
    expect(x.and(y), Ok("different result type"));
  });

  test("andThen",(){
    Result<String,String> sqThenToString(int x) {
      if(x > 10000){
        return Err("overflowed");
      }
      return Ok<int,String>(x * x).map((s) =>s.toString());
    }

    expect(Ok(2).andThen(sqThenToString), Ok(4.toString()));
    expect(Ok(1000000).andThen(sqThenToString), Err("overflowed"));
    expect(Err<int,String>("not a number").andThen(sqThenToString), Err("not a number"));
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

    final none = const None<int>();
    try {
      none.expect("Error occurred");
      fail("Should have thrown an error");
    } catch (e) {
      expect(e.toString(), contains("Error occurred"));
    }
  });

  test("filter",(){
      bool isEven(int n) => n % 2 == 0;

      Option<int> none = const None();
      Option<int> some3 = Some(3);
      Option<int> some4 = Some(4);

      expect(none.filter(isEven), const None());
      expect(some3.filter(isEven), const None());
      expect(some4.filter(isEven), const Some(4));
  });

  test("inspect",(){
    final x = Ok(1);
    int? y;
    x.inspect((e) {
      y = e;
    });
    expect(y, 1);
    final w = const None<int>();
    w.inspect((e) {
      y = e + 4;
    });
    expect(y,1);
  });

  test("isNone", () {
    Option<int> x = Some(2);
    expect(x.isNone(), false);

    Option<int> y = const None();
    expect(y.isNone(), true);
  });

  test("isSome", () {
    Option<int> x = Some(2);
    expect(x.isSome(), true);

    Option<int> y = const None();
    expect(y.isSome(), false);
  });

  test("isSomeAnd", () {
    Option<int> x = Some(2);
    expect(x.isSomeAnd((x) => x > 1), true);

    Option<int> y = Some(0);
    expect(y.isSomeAnd((y) => y > 1), false);

    Option<int> z = const None();
    expect(z.isSomeAnd((z) => z > 1), false);
  });

  test("iterNext", () {
    Option<int> x = Some(4);
    var it = x.iter().iterator;
    it.moveNext();
    expect(it.current, 4);

    Option<int> y = const None();
    it = y.iter().iterator;
    expect(it.moveNext(), false);
  });

  test("map", () {
    Option<String> maybeSomeString = Some("Hello, World!");
    Option<int> maybeSomeLen = maybeSomeString.map((s) => s.length);
    expect(maybeSomeLen, Some(13));

    Option<String> x = const None();
    expect(x.map((s) => s.length), const None());
  });

  test("mapOr", () {
    Option<String> x = Some("foo");
    expect(x.mapOr(42, (v) => v.length), 3);

    Option<String> y = const None();
    expect(y.mapOr(42, (v) => v.length), 42);
  });

  test("mapOrElse", () {
    int k = 21;

    Option<String> x = Some("foo");
    expect(x.mapOrElse(() => 2 * k, (v) => v.length), 3);

    Option<String> y = const None();
    expect(y.mapOrElse(() => 2 * k, (v) => v.length), 42);
  });

  test("okOr", () {
    Option<String> x = Some("foo");
    expect(x.okOr(0), Ok("foo"));

    Option<String> y = const None();
    expect(y.okOr(0), Err(0));
  });

  test("okOrElse", () {
    Option<String> x = Some("foo");
    expect(x.okOrElse(() => 0), Ok("foo"));

    Option<String> y = const None();
    expect(y.okOrElse(() => 0), Err(0));
  });

  test("or", () {
    Option<int> x = Some(2);
    Option<int> y = const None();
    expect(x.or(y), Some(2));

    x = const None();
    y = Some(100);
    expect(x.or(y), Some(100));

    x = Some(2);
    y = Some(100);
    expect(x.or(y), Some(2));

    x = const None();
    y = const None();
    expect(x.or(y), const None());
  });

  Option<String> nobody() => const None();
  Option<String> vikings() => Some("vikings");

  test("orElse", () {
    expect(Some("barbarians").orElse(vikings), Some("barbarians"));
    expect(const None<String>().orElse(vikings), Some("vikings"));
    expect(const None<String>().orElse(nobody), const None());
  });

  test("unwrap", () {
    Option<String> x = Some("air");
    expect(x.unwrap(), "air");

    x = const None();
    Object? w;
    try{
      x.unwrap();
    } catch(e){
      w=e;
    }
    expect(w, isA<Error>());
  });

  test("unwrapOr", () {
    expect(Some("car").unwrapOr("bike"), "car");
    expect(const None<String>().unwrapOr("bike"), "bike");
  });

  test("unwrapOrElse", () {
    int k = 10;
    expect(Some(4).unwrapOrElse(() => 2 * k), 4);
    expect(const None<int>().unwrapOrElse(() => 2 * k), 20);
  });

  test("xor", () {
    Option<int> x = Some(2);
    Option<int> y = const None();
    expect(x.xor(y), Some(2));

    x = const None();
    y = Some(2);
    expect(x.xor(y), Some(2));

    x = Some(2);
    y = Some(2);
    expect(x.xor(y), const None());

    x = const None();
    y = const None();
    expect(x.xor(y), const None());
  });

  test("zip", () {
    Option<int> x = Some(1);
    Option<String> y = Some("hi");
    Option<int> z = const None();

    expect(x.zip(y), Some((1, "hi")));
    expect(x.zip(z), const None());
  });

  test("zipWith", () {
    Option<double> x = Some(17.5);
    Option<double> y = Some(42.7);
    Option<Point> nonePoint = const None();

    expect(x.zipWith(y, (a, b) => Point(a, b)), Some(Point(17.5, 42.7)));
    expect(x.zipWith(nonePoint, (a, b) => Point(a, b.x)), const None());
  });

  group("Option Early Return",(){
    Option<int> intSome() => Some(1);
    Option<int> intNone() => const None();

    test('Do Notation No Exit', () {
      Option<int> earlyReturn(int val) => Option.$(($){
          int x = intSome()[$];
          return Some(val + 3);
        });
      expect(earlyReturn(2).unwrap(), 5);
    });

    test('Do Notation With Exit', () {
      Option<int> earlyReturn(int val) => Option.$(($){
        int x = intNone()[$];
        return Some(val + 3);
      });
      expect(earlyReturn(2), const None());
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
