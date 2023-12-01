import 'package:rust_core/core.dart';

import 'package:test/test.dart';

void main() {

  test('flatten', () {
    Result<Result<int, X>, Y> w = Ok(Ok(0));
    expect(w.flatten(), isA<Result<int, X>>());
    Result<Result<int, Y>, X> v = Ok(Ok(0));
    expect(v.flatten(), isA<Result<int, Y>>());
  });

  test('transpose Result Null', () {
    Result<String?, int> x = Ok(null);
    expect(x.transpose(), null);
    x = Ok("");
    expect(x.transpose()?.unwrap(), "");
  });

  test('transpose Null Result', () {
    Result<String, int>? x;
    expect(x.transposeNullable(), Ok(null));
    x = Ok("");
    expect(x.transposeNullable().unwrap(), "");
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

class X extends Object {}

class Y extends X {}

class Z {}

FutureResult<int, int> _delay(Result<int, int> result) {
  int delay = result.isOk() ? result.unwrap() : result.unwrapErr();
  return Future.value(result).then((value) async {
    await Future.delayed(Duration(seconds: delay));
    return result;
  });
}
