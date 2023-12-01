import 'package:rust_core/rust_core.dart';
import 'package:test/test.dart';

void main() {
  test('Ok Null', () {
    final result = Ok(null);
    expect(result.unwrap(), null);
  });

  test('Ok Null Result', () {
    Result<Null, Object> fn() {
      return Ok(null);
    }

    final result = fn();
    expect(result.unwrap(), null);
  });

  test('Ok', () {
    final result = Ok(0);
    expect(result.unwrap(), 0);
  });

  test('Err', () {
    final result = Err(0);
    expect(result.unwrapErr(), 0);
  });

  test("isOk", () {
    Result result = Ok(0);
    late int ok;
    if (result.isOk()) {
      ok = result.unwrap();
    }

    expect(ok, isA<int>());
    expect(result.isErr(), isFalse);
  });

  test("isOkAnd", () {
    Result result = Ok(0);
    late int ok;
    if (result.isOkAnd((r) => true)) {
      ok = result.unwrap();
    }

    expect(ok, isA<int>());
    expect(result.isErr(), isFalse);
  });

  test("isErr", () {
    Result<dynamic, int> result = Err(0);
    late int err;
    if (result.isErr()) {
      err = result.unwrapErr();
    }

    expect(err, isA<int>());
    expect(result.isOk(), isFalse);
  });

  test("isErrAnd", () {
    Result<dynamic, int> result = Err(0);
    late int err;
    if (result.isErrAnd((r) => true)) {
      err = result.unwrapErr();
    }

    expect(err, isA<int>());
    expect(result.isOk(), isFalse);
  });

  test("iter", () {
    Result<int, Object> result = Ok(10000);
    int calls = 0;
    for (final _ in result.iter()) {
      calls++;
    }
    expect(calls, 1);
    result = Err(1);
    for (final _ in result.iter()) {
      calls++;
    }
    expect(calls, 1);
  });

  test("and", () {
    Result<int, Object> x = Ok(2);
    Result<String, Object> y = Err("late error");
    expect(x.and(y), Err("late error"));

    x = Err("early error");
    y = Ok("foo");
    expect(x.and(y), Err("early error"));

    x = Err("not a 2");
    y = Err("late error");
    expect(x.and(y), Err("not a 2"));

    x = Ok(2);
    y = Err("different result type");
    expect(x.and(y), Err("different result type"));
  });

  test("or", () {
    Result<int, Object> x = Ok(2);
    Result<int, String> y = Err("late error");
    expect(x.or(y), Ok(2));

    x = Err("early error");
    y = Ok(2);
    expect(x.or(y), Ok(2));

    x = Err("not a 2");
    y = Err("late error");
    expect(x.or(y), Err("late error"));

    x = Ok(2);
    y = Ok(100);
    expect(x.or(y), Ok(2));
  });

  test('equatable', () {
    expect(const Ok(1) == const Ok(1), isTrue);
    expect(const Ok(1).hashCode == const Ok(1).hashCode, isTrue);

    expect(Err(1) == Err(1), isTrue);
    expect(Err(1).hashCode == Err(1).hashCode, isTrue);
  });

  group('map', () {
    test('Ok', () {
      final result = Ok(4);
      final result2 = result.map((ok) => '=' * ok);

      expect(result2.unwrapOrNull(), '====');
    });

    test('Err', () {
      final result = Err<int, Object>(4);
      final result2 = result.map((ok) => 'change');

      expect(result2.unwrapOrNull(), isNull);
      expect(result2.unwrapErrOrNull(), 4);
    });
  });

  group('mapOr', () {
    test('Ok', () {
      final result = Ok(1).mapOr(2, (ok) => 3);
      expect(result, 3);
    });

    test('Err', () {
      final result = Err(1).mapOr(2, (ok) => 3);
      expect(result, 2);
    });
  });

  group('mapOrElse', () {
    test('Ok', () {
      final result = Ok(1).mapOrElse((err) => 2, (ok) => 3);
      expect(result, 3);
    });

    test('Err', () {
      final result = Err(1).mapOrElse((err) => 2, (ok) => 3);
      expect(result, 2);
    });
  });

  group('mapErr', () {
    test('Ok', () {
      const result = Ok<int, int>(4);
      final result2 = result.mapErr((error) => '=' * error);

      expect(result2.unwrapOrNull(), 4);
      expect(result2.unwrapErrOrNull(), isNull);
    });

    test('Err', () {
      final result = 4.toErr();
      final result2 = result.mapErr((error) => 'change');

      expect(result2.unwrapOrNull(), isNull);
      expect(result2.unwrapErrOrNull(), 'change');
    });
  });

  group('andThan', () {
    test('Ok', () {
      final result = 4.toOk();
      final result2 = result.andThen((ok) => Ok('=' * ok));

      expect(result2.unwrapOrNull(), '====');
    });

    test('Err', () {
      final result = 4.toErr();
      final result2 = result.andThen(Ok.new);

      expect(result2.unwrapOrNull(), isNull);
      expect(result2.unwrapErrOrNull(), 4);
    });
  });

  group('andThenErr', () {
    test('Err', () {
      final result = 4.toErr();
      final result2 = result.andThenErr((error) => ('=' * error).toErr());

      expect(result2.unwrapErrOrNull(), '====');
    });

    test('Ok', () {
      const result = Ok(4);
      final result2 = result.andThenErr(Err.new);

      expect(result2.unwrapOrNull(), 4);
      expect(result2.unwrapErrOrNull(), isNull);
    });
  });

  group('match', () {
    test('Ok', () {
      const result = Ok(0);
      final futureValue = result.match(err: (e) => -1, ok: (x) => x);
      expect(futureValue, 0);
    });

    test('Err', () {
      final result = 0.toErr();
      final futureValue = result.match(err: (x) => x, ok: (ok) => -1);
      expect(futureValue, 0);
    });
  });

  group('unwrap', () {
    test('Ok', () {
      const result = Ok(0);
      expect(result.unwrap(), 0);
    });

    test('Err', () {
      final result = 0.toErr();
      expect(result.unwrap, throwsA(isA<Panic>()));
    });
  });

  group('unwrapOr', () {
    test('Ok', () {
      final result = Ok(0);
      final value = result.unwrapOr(-1);
      expect(value, 0);
    });

    test('Err', () {
      final result = Err(0);
      final value = result.unwrapOr(2);
      expect(value, 2);
    });
  });

  group('unwrapOrElse', () {
    test('Ok', () {
      final result = Ok(0);
      final value = result.unwrapOrElse((f) => -1);
      expect(value, 0);
    });

    test('Err', () {
      final result = Err(0);
      final value = result.unwrapOrElse((f) => 2);
      expect(value, 2);
    });
  });

  group('unwrapOrNull', () {
    test('Ok', () {
      const result = Ok<int, int>(0);
      final value = result.unwrapOrNull();
      expect(value, 0);
    });

    test('Err', () {
      final result = Err(0);
      final value = result.unwrapOrNull();
      expect(value, null);
    });
  });

  group('unwrapErr', () {
    test('Ok', () {
      const result = Ok(0);
      expect(result.unwrapErr, throwsA(isA<Panic>()));
    });

    test('Err', () {
      final result = Err(0);
      expect(result.unwrapErr(), 0);
    });
  });

  group('unwrapErrOr', () {
    test('Ok', () {
      final result = Ok(0);
      final value = result.unwrapErrOr("");
      expect(value, "");
    });

    test('Err', () {
      final result = Err<bool, Object>(0);
      final value = result.unwrapErrOr("");
      expect(value, 0);
    });
  });

  group('inspect', () {
    test('Ok', () {
      const Ok(0).inspectErr((error) {}).inspect(
        expectAsync1(
          (value) {
            expect(value, 0);
          },
        ),
      );
    });

    test('Err', () {
      Err('error').inspect((ok) {}).inspectErr(
        expectAsync1(
          (value) {
            expect(value, 'error');
          },
        ),
      );
    });
  });

  group('unwrapErrOrElse', () {
    test('Ok', () {
      const result = Ok(0);
      final value = result.unwrapErrOrElse((f) => "");
      expect(value, "");
    });

    test('Err', () {
      final result = Err(0);
      final value = result.unwrapErrOrElse((f) => 2);
      expect(value, 0);
    });
  });

  group('unwrapErrOrNull', () {
    test('Ok', () {
      const result = Ok(0);
      final value = result.unwrapErrOrNull();
      expect(value, null);
    });

    test('Err', () {
      final result = Err<int, String>("");
      final value = result.unwrapErrOrNull();
      expect(value, "");
    });
  });

  Result<int, int> sq(int x) => Ok(x * x);
  Result<int, int> err(int x) => Err(x);

  test("orElse", () {
    expect(Ok<int, int>(2).orElse(sq).orElse(sq), Ok(2));
    expect(Ok<int, int>(2).orElse(err).orElse(sq), Ok(2));
    expect(Err(3).orElse(sq).orElse(err), Ok(9));
    expect(Err(3).orElse(err).orElse(err), Err(3));
  });

  test("intoUnchecked and into", () {
    Result<int, String> someFunction1() {
      return Err("err");
    }

    Result<String, String> someFunction2() {
      final result = someFunction1();
      if (result case Err()) {
        return result.into();
      }
      return Ok("ok");
    }

    expect(someFunction2().unwrapErr(), "err");
    expect(Err(0).intoUnchecked<String>().unwrapErr(), 0);
    expect(() => Ok(0).intoUnchecked<String>(), throwsA(isA<Panic>()));
    expect(Ok(0).intoUnchecked<num>().unwrap(), 0);
    expect(Err(0).intoUnchecked().unwrapErr(), 0);
    expect(Ok(0).intoUnchecked().unwrap(), 0);
    expect(Ok(0).intoUnchecked().unwrap(), 0);

    Result<int, String> someFunction3() {
      return Err("err");
    }

    Result<String, String> someFunction4() {
      final result = someFunction3();
      if (result is Err<int, String>) {
        return result.into();
      }
      return Ok("ok");
    }

    expect(someFunction4().unwrapErr(), "err");
    expect(Err(0).into<String>().unwrapErr(), 0);
    // expect(() => Ok(0).into<String>(),throwsA(isA<Panic>()));
    // expect(Ok(0).into<num>().unwrap(),0);
    expect(Err(0).into().unwrapErr(), 0);
    // expect(Ok(0).into().unwrap(),0);
    // expect(Ok(0).into().unwrap(),0);
  });

  //************************************************************************//

  test('Do Notation No Exit', () {
    Result<int, String> anotherResultFn() {
      return Ok(1);
    }

    Result<int, String> add3(int val) {
      return Result.$(($){
        int x = anotherResultFn().$($);
        int y = Ok(1).$($);
        int z = Ok(1).mapErr((err) => err.toString()).$($);
        x + y + z;
        return Ok(val + x + y + z);
      });
    }
      expect(add3(2).unwrap(), 5);
  });

  test('Do Notation With Exit', () {
    Result<int, String> innerFn() {
      return Err("message");
    }

    Result<int, String> testDoNotation() => Result.$(($) {
          int y = Ok(1).$($);
          int z = Ok(1).mapErr((err) => err.toString()).$($);
          int x = innerFn().$($);
          x + y + z;
          return Ok(x + y + z);
        });
    expect(testDoNotation().unwrapErr(), "message");
  });
}