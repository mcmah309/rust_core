import 'package:anyhow/anyhow.dart';
import 'package:test/test.dart';

void main() {
  test('Ok Null', () {
    final result = Ok(null);
    expect(result.unwrap(), null);
  });

  test('Ok Null Result', () {
    Result<Null> fn() {
      return Ok(null);
    }

    final result = fn();
    expect(result.unwrap(), null);
  });

  test('Ok', () {
    final result = Ok(0);
    expect(result.unwrap(), 0);
  });

  test('Error', () {
    final result = bail(0);
    expect(result.unwrapErr().downcast<int>().unwrap(), 0);
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
    Result<dynamic> result = bail(0);
    late int err;
    if (result.isErr()) {
      err = result.unwrapErr().downcast<int>().unwrap();
    }

    expect(err, isA<int>());
    expect(result.isOk(), isFalse);
  });

  test("isErrAnd", () {
    Result<dynamic> result = bail(0);
    late int err;
    if (result.isErrAnd((r) => true)) {
      err = result.unwrapErr().downcast<int>().unwrap();
    }

    expect(err, isA<int>());
    expect(result.isOk(), isFalse);
  });

  test("iter", () {
    Result<int> result = Ok(10000);
    int calls = 0;
    for (final _ in result.iter()) {
      calls++;
    }
    expect(calls, 1);
    result = bail(1);
    for (final _ in result.iter()) {
      calls++;
    }
    expect(calls, 1);
  });

  test("and", () {
    Result<int> x = Ok(2);
    Result<String> y = bail("late error");
    expect(x.and(y), bail("late error"));

    x = bail("early error");
    y = Ok("foo");
    expect(x.and(y), bail("early error"));

    x = bail("not a 2");
    y = bail("late error");
    expect(x.and(y), bail("not a 2"));

    x = Ok(2);
    y = bail("different result type");
    expect(x.and(y), bail("different result type"));
  });

  test("or", () {
    Result<int> x = Ok(2);
    Result<int> y = bail("late error");
    expect(x.or(y), Ok(2));

    x = bail("early error");
    y = Ok(2);
    expect(x.or(y), Ok(2));

    x = bail("not a 2");
    y = bail("late error");
    expect(x.or(y), bail("late error"));

    x = Ok(2);
    y = Ok(100);
    expect(x.or(y), Ok(2));
  });

  test('equatable', () {
    expect(const Ok(1) == const Ok(1), isTrue);
    expect(const Ok(1).hashCode == const Ok(1).hashCode, isTrue);

    expect(bail(1) == bail(1), isTrue);
    expect(bail(1).hashCode == bail(1).hashCode, isTrue);
  });

  group('map', () {
    test('Ok', () {
      final result = Ok(4);
      final result2 = result.map((ok) => '=' * ok);

      expect(result2.unwrapOrNull(), '====');
    });

    test('Error', () {
      final result = Err<String>(Error(4));
      final result2 = result.map((ok) => 'change');

      expect(result2.unwrapOrNull(), isNull);
      expect(result2.unwrapErrOrNull().downcast<int>().unwrap(), 4);
    });
  });

  group('mapOr', () {
    test('Ok', () {
      final result = Ok(1).mapOr(2, (ok) => 3);
      expect(result, 3);
    });

    test('Error', () {
      final result = bail(1).mapOr(2, (ok) => 3);
      expect(result, 2);
    });
  });

  group('mapOrElse', () {
    test('Ok', () {
      final result = Ok(1).mapOrElse((err) => 2, (ok) => 3);
      expect(result, 3);
    });

    test('Error', () {
      final result = bail(1).mapOrElse((err) => 2, (ok) => 3);
      expect(result, 2);
    });
  });

  group('mapErr', () {
    test('Ok', () {
      const result = Ok<int>(4);
      final result2 =
          result.mapErr((error) => Error('=' * error.downcast<int>().unwrap()));

      expect(result2.unwrapOrNull(), 4);
      expect(result2.unwrapErrOrNull(), isNull);
    });

    test('Error', () {
      final result = 4.toErr();
      final result2 = result.mapErr((error) => Error('change'));

      expect(result2.unwrapOrNull(), isNull);
      expect(result2.unwrapErrOrNull(), Error('change'));
    });
  });

  group('andThn', () {
    test('Ok', () {
      final result = 4.toOk();
      final result2 = result.andThen((ok) => Ok('=' * ok));

      expect(result2.unwrapOrNull(), '====');
    });

    test('Error', () {
      final result = 4.toErr();
      final result2 = result.andThen(Ok.new);

      expect(result2.unwrapOrNull(), isNull);
      expect(result2.unwrapErrOrNull(), Error(4));
    });
  });

  group('andThenError', () {
    test('Error', () {
      final result = 4.toErr();
      final result2 = result.andThenErr(
          (error) => ('=' * error.downcast<int>().unwrap()).toErr());

      expect(result2.unwrapErrOrNull(), Error('===='));
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

    test('Error', () {
      final result = 0.toErr();
      final futureValue = result.match(err: (x) => x, ok: (ok) => -1);
      expect(futureValue, Error(0));
    });
  });

  group('unwrap', () {
    test('Ok', () {
      const result = Ok(0);
      expect(result.unwrap(), 0);
    });

    test('Error', () {
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

    test('Error', () {
      final result = bail(0);
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

    test('Error', () {
      final result = bail(0);
      final value = result.unwrapOrElse((f) => 2);
      expect(value, 2);
    });
  });

  group('unwrapOrNull', () {
    test('Ok', () {
      const result = Ok<int>(0);
      final value = result.unwrapOrNull();
      expect(value, 0);
    });

    test('Error', () {
      final result = bail(0);
      final value = result.unwrapOrNull();
      expect(value, null);
    });
  });

  group('unwrapErr', () {
    test('Ok', () {
      const result = Ok(0);
      expect(result.unwrapErr, throwsA(isA<Panic>()));
    });

    test('Error', () {
      final result = bail(0);
      expect(result.unwrapErr(), Error(0));
    });
  });

  group('unwrapErrOr', () {
    test('Ok', () {
      final result = Ok(0);
      final value = result.unwrapErrOr(Error(""));
      expect(value, Error(""));
    });

    test('Error', () {
      final result = bail(0);
      final value = result.unwrapErrOr(Error(""));
      expect(value, Error(0));
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

    test('Error', () {
      bail('error').inspect((ok) {}).inspectErr(
        expectAsync1(
          (value) {
            expect(value, Error('error'));
          },
        ),
      );
    });
  });

  group('unwrapErrOrElse', () {
    test('Ok', () {
      const result = Ok(0);
      final value = result.unwrapErrOrElse((f) => Error(""));
      expect(value, Error(""));
    });

    test('Error', () {
      final result = bail(0);
      final value = result.unwrapErrOrElse((f) => Error(2));
      expect(value, Error(0));
    });
  });

  group('unwrapErrOrNull', () {
    test('Ok', () {
      const result = Ok(0);
      final value = result.unwrapErrOrNull();
      expect(value, null);
    });

    test('Error', () {
      final result = Err<int>(Error(0));
      final value = result.unwrapErrOrNull();
      expect(value, Error(0));
    });
  });

  test("context", () {
    final result = bail(1).context("bing bong").context("bong bing");
    List<Object> causes = [];
    for (final (index, cause) in result.err.chain().indexed) {
      if (index == 2) {
        causes.add(cause.downcast<int>().unwrap());
      } else {
        causes.add(cause.downcast<String>().unwrap());
      }
    }
    expect(causes[0], "bong bing");
    expect(causes[1], "bing bong");
    expect(causes[2], 1);
  });

  test("withContext", () {
    final result =
        bail(1).withContext(() => "bing bong").withContext(() => "bong bing");
    List<Object> causes = [];
    for (final (index, cause) in result.err.chain().indexed) {
      if (index == 2) {
        causes.add(cause.downcast<int>().unwrap());
      } else {
        causes.add(cause.downcast<String>().unwrap());
      }
    }
    expect(causes[0], "bong bing");
    expect(causes[1], "bing bong");
    expect(causes[2], 1);
  });

  test("toResult on Iterable", () {
    var result = [Ok(1), Ok(2), Ok(3)].toResult();
    expect(result.unwrap(), [1, 2, 3]);

    result = [Ok<int>(1), bail<int>(2), Ok<int>(3)].toResult();
    expect(
        result
            .unwrapErr()
            .downcast<List<Error>>()
            .unwrap()[0]
            .downcast<int>()
            .unwrap(),
        2);

    result = [Ok<int>(1), bail<int>(2), bail<int>(3)].toResult();
    expect(
        result
            .unwrapErr()
            .downcast<List<Error>>()
            .unwrap()[0]
            .downcast<int>()
            .unwrap(),
        2);
    expect(
        result
            .unwrapErr()
            .downcast<List<Error>>()
            .unwrap()[1]
            .downcast<int>()
            .unwrap(),
        3);
  });

  test("merge on Iterable", () {
    var result = [Ok(1), Ok(2), Ok(3)].merge();
    expect(result.unwrap(), [1, 2, 3]);

    result = [Ok<int>(1), bail<int>(2), Ok<int>(3)].merge();
    expect(result.unwrapErr().downcast<int>().unwrap(), 2);
    expect(result.unwrapErr().rootCause().downcast<int>().unwrap(), 2);

    result = [Ok<int>(1), bail<int>(2), bail<int>(3)].merge();
    expect(result.unwrapErr().downcast<int>().unwrap(), 3);
    expect(result.unwrapErr().rootCause().downcast<int>().unwrap(), 2);
  });

  test("toErr overriden for Error", () {
    expect(1.toErr(), Err(Error(1)));
    expect(Error(1).toErr(), Err(Error(1)));
  });

  test('printing error', () {
    Error.hasStackTrace = false;
    Result error = bail(Exception("Root cause"));
    Error.displayFormat = ErrDisplayFormat.traditionalAnyhow;
    expect(error.toString(), 'Error: Exception: Root cause\n');
    Error.displayFormat = ErrDisplayFormat.rootCauseFirst;
    expect(error.toString(), 'Root Cause: Exception: Root cause\n');
    error = order();
    Error.displayFormat = ErrDisplayFormat.traditionalAnyhow;
    //print(error.toString());
    expect(error.toString(), """
Error: Bob ordered.

Caused by:
	0: order was pizza.
	1: Hmm something went wrong making the hamburger.
""");
    Error.displayFormat = ErrDisplayFormat.rootCauseFirst;
    // print(error.toString());
    expect(error.toString(), """
Root Cause: Hmm something went wrong making the hamburger.

Additional Context:
	0: order was pizza.
	1: Bob ordered.
""");
  });

  test('printing error with stacktrace', () {
    Error.hasStackTrace = true;
    Error.stackTraceDisplayFormat = StackTraceDisplayFormat.none;
    Result error = bail(Exception("Root cause"));
    Error.displayFormat = ErrDisplayFormat.traditionalAnyhow;
    expect(error.toString(), 'Error: Exception: Root cause\n');
    Error.displayFormat = ErrDisplayFormat.rootCauseFirst;
    expect(error.toString(), 'Root Cause: Exception: Root cause\n');
    error = order();
    Error.displayFormat = ErrDisplayFormat.traditionalAnyhow;
    //print(error.toString());
    expect(error.toString(), """
Error: Bob ordered.

Caused by:
	0: order was pizza.
	1: Hmm something went wrong making the hamburger.
""");
    Error.displayFormat = ErrDisplayFormat.rootCauseFirst;
    // print(error.toString());
    expect(error.toString(), """
Root Cause: Hmm something went wrong making the hamburger.

Additional Context:
	0: order was pizza.
	1: Bob ordered.
""");

    Error.stackTraceDisplayFormat = StackTraceDisplayFormat.one;
    error = bail(Exception("Root cause"));
    Error.displayFormat = ErrDisplayFormat.traditionalAnyhow;
    expect(error.toString(), startsWith("""
Error: Exception: Root cause

StackTrace:
"""));
    Error.displayFormat = ErrDisplayFormat.rootCauseFirst;
    expect(error.toString(), startsWith("""
Root Cause: Exception: Root cause

StackTrace:
"""));
    error = order();
    Error.displayFormat = ErrDisplayFormat.traditionalAnyhow;
    //print(error.toString());
    expect(error.toString(), startsWith("""
Error: Bob ordered.

Caused by:
	0: order was pizza.
	1: Hmm something went wrong making the hamburger.

StackTrace:
"""));
    Error.displayFormat = ErrDisplayFormat.rootCauseFirst;
    // print(error.toString());
    expect(error.toString(), startsWith("""
Root Cause: Hmm something went wrong making the hamburger.

Additional Context:
	0: order was pizza.
	1: Bob ordered.

StackTrace:
"""));

    Error.stackTraceDisplayFormat = StackTraceDisplayFormat.full;
    error = bail(Exception("Root cause"));
    Error.displayFormat = ErrDisplayFormat.traditionalAnyhow;
    expect(error.toString(), startsWith("""
Error: Exception: Root cause

Main StackTrace:
"""));
    expect(error.toString(), isNot(contains("Additional StackTraces")));
    Error.displayFormat = ErrDisplayFormat.rootCauseFirst;
    expect(error.toString(), startsWith("""
Root Cause: Exception: Root cause

Main StackTrace:
"""));
    expect(error.toString(), isNot(contains("Additional StackTraces")));
    error = order();
    Error.displayFormat = ErrDisplayFormat.traditionalAnyhow;
    //print(error.toString());
    expect(error.toString(), startsWith("""
Error: Bob ordered.

Caused by:
	0: order was pizza.
	1: Hmm something went wrong making the hamburger.

Main StackTrace:
"""));
    expect(error.toString(), contains("Additional StackTraces"));
    Error.displayFormat = ErrDisplayFormat.rootCauseFirst;
    // print(error.toString());
    expect(error.toString(), startsWith("""
Root Cause: Hmm something went wrong making the hamburger.

Additional Context:
	0: order was pizza.
	1: Bob ordered.

Main StackTrace:
"""));
    expect(error.toString(), contains("Additional StackTraces"));
  });
}

Result order() {
  final user = "Bob";
  final food = "pizza";
  return makeFood(food).context("$user ordered.");
}

Result makeFood(String order) {
  return makeHamburger().context("order was $order.");
}

Result makeHamburger() {
  return bail("Hmm something went wrong making the hamburger.");
}
