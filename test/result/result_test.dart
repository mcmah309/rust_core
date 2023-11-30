import 'package:anyhow/anyhow.dart' as anyhow;
import 'package:anyhow/base.dart';
import 'package:test/test.dart';

/// Tests specific to the base Result, most other methods are tested with Anyhow
void main() {
  test("Unit", () {
    Result<Unit, void> x = Ok(());
    Result<(), void> y = Ok(unit);
    expect(x, y);
    Result<void, Unit> a = Err(());
    Result<Unit, ()> b = Err(unit);
    expect(a, b);
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

  test("toAnyhowResult", () {
    Result<int, String> x = Ok(1);
    expect(x.toAnyhowResult().unwrap(), 1);
    x = Err("err");
    expect(x.toAnyhowResult().unwrapErr().downcast<String>().unwrap(), "err");
    expect(identical(x, x.toAnyhowResult()), false);

    Ok<int, String> y = Ok(1);
    expect(y.toAnyhowResult().unwrap(), 1);
    Err<int, String> w = Err("err");
    expect(w.toAnyhowResult().unwrapErr().downcast<String>().unwrap(), "err");
    expect(identical(y, y.toAnyhowResult()), false);
    expect(identical(w, w.toAnyhowResult()), false);

    anyhow.Result<int> z = anyhow.Ok(1);
    expect(z.toAnyhowResult().unwrap(), 1);
    z = anyhow.bail("err");
    expect(z.toAnyhowResult().unwrapErr().downcast<String>().unwrap(), "err");
    expect(identical(z, z.toAnyhowResult()), true);
  });

  test("toFutureResult", () async {
    FutureResult<int, String> x = Ok<int, String>(1).toFutureResult();
    expect(await x.unwrap(), 1);
    FutureResult<int, String> y = Err<int, String>("err").toFutureResult();
    expect(await y.unwrapErr(), "err");

    // converts to Future<Result<int,String>> rather than Future<Result<Future<int>,String>>
    Result<Future<int>, String> z = Ok(Future.value(1));
    expect(await z.toFutureResult().unwrap(), 1);
    z = Err("err");
    expect(await z.toFutureResult().unwrapErr(), "err");
  });

  test("toResultEager on Iterable", () {
    var result = [Ok(1), Ok(2), Ok(3)].toResultEager();
    expect(result.unwrap(), [1, 2, 3]);

    result =
        [Ok<int, int>(1), Err<int, int>(2), Ok<int, int>(3)].toResultEager();
    expect(result.unwrapErr(), 2);

    result =
        [Ok<int, int>(1), Err<int, int>(2), Err<int, int>(3)].toResultEager();
    expect(result.unwrapErr(), 2);

    result = [
      Ok<int, int>(1),
      Err<int, int>(3),
      Err<int, int>(2),
      Ok<int, int>(4)
    ].toResultEager();
    expect(result.unwrapErr(), 3);
  });

  test("toResult on Iterable", () {
    var result = [Ok(1), Ok(2), Ok(3)].toResult();
    expect(result.unwrap(), [1, 2, 3]);

    result = [Ok<int, int>(1), Err<int, int>(2), Ok<int, int>(3)].toResult();
    expect(result.unwrapErr(), [2]);

    result = [Ok<int, int>(1), Err<int, int>(2), Err<int, int>(3)].toResult();
    expect(result.unwrapErr(), [2, 3]);

    result = [
      Ok<int, int>(1),
      Err<int, int>(3),
      Err<int, int>(2),
      Ok<int, int>(4)
    ].toResult();
    expect(result.unwrapErr(), [3, 2]);
  });

  test("toResultEager on Future Iterable", () async {
    var result =
        await [_delay(Ok(3)), _delay(Ok(1)), _delay(Ok(2))].toResultEager();
    expect(result.unwrap(), [1, 2, 3]);

    result = await [
      _delay(Ok<int, int>(3)),
      _delay(Err<int, int>(1)),
      _delay(Ok<int, int>(2))
    ].toResultEager();
    expect(result.unwrapErr(), 1);

    result = await [
      _delay(Ok<int, int>(1)),
      _delay(Err<int, int>(3)),
      _delay(Err<int, int>(2))
    ].toResultEager();
    expect(result.unwrapErr(), 2);

    result = await [
      _delay(Ok<int, int>(1)),
      _delay(Err<int, int>(2)),
      _delay(Err<int, int>(3)),
      _delay(Ok<int, int>(4))
    ].toResultEager();
    expect(result.unwrapErr(), 2);
  });

  test("toResult on Future Iterable", () async {
    var result = await [_delay(Ok(3)), _delay(Ok(1)), _delay(Ok(2))].toResult();
    expect(result.unwrap(), [3, 1, 2]);

    result = await [
      _delay(Ok<int, int>(3)),
      _delay(Err<int, int>(1)),
      _delay(Ok<int, int>(2))
    ].toResult();
    expect(result.unwrapErr(), [1]);

    result = await [
      _delay(Ok<int, int>(1)),
      _delay(Err<int, int>(3)),
      _delay(Err<int, int>(2))
    ].toResult();
    expect(result.unwrapErr(), [3, 2]);

    result = await [
      _delay(Ok<int, int>(1)),
      _delay(Err<int, int>(2)),
      _delay(Err<int, int>(3)),
      _delay(Ok<int, int>(4))
    ].toResult();
    expect(result.unwrapErr(), [2, 3]);
  });
}

FutureResult<int, int> _delay(Result<int, int> result) {
  int delay = result.isOk() ? result.unwrap() : result.unwrapErr();
  return Future.value(result).then((value) async {
    await Future.delayed(Duration(seconds: delay));
    return result;
  });
}
