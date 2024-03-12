import 'package:rust_core/panic.dart';
import 'package:rust_core/result.dart';
import 'package:test/test.dart';

void main() {
  group('andThen', () {
    test('async ', () async {
      final result = await Future.value(const Ok(1)).andThen((ok) async => Ok(ok * 2));
      expect(result.unwrapOrNull(), 2);
    });

    test('sink', () async {
      final result = await Future.value(const Ok(1)).andThen((ok) => Ok(ok * 2));
      expect(result.unwrapOrNull(), 2);
    });
  });

  group('andThenError', () {
    test('async ', () async {
      final result = await Future.value(Err(2)).andThenErr((error) async => Err(error * 2));
      expect(result.unwrapErr(), 4);
    });

    test('sink', () async {
      final result = await Future.value(Err(2)).andThenErr((error) => Err(error * 2));
      expect(result.unwrapErr(), 4);
    });
  });

  group('match', () {
    test('Ok', () async {
      final result = Future.value(const Ok(0));
      final futureValue = result.match(err: (e) => -1, ok: (x) => x);
      expect(futureValue, completion(0));
    });

    test('Error', () async {
      final result = Future.value(Err(0));
      final futureValue = result.match(err: (e) => e, ok: (x) => x);
      expect(futureValue, completion(0));
    });
  });

  test('map', () async {
    final result = await Future.value(const Ok(1)).map((ok) => ok * 2);

    expect(result.unwrapOrNull(), 2);
    expect(Future.value(Err(2)).map((x) => x), completes);
  });

  test('mapErr', () async {
    final result = await Future.value(Err(1)).mapErr((error) => Err(error * 2));
    expect(result.unwrapErr().unwrapErr(), 2);
    expect(Future.value(const Ok(2)).mapErr((x) => x), completes);
  });

  group('mapOrElse', () {
    test('Ok', () async {
      final result = Future.value(const Ok(0));
      final futureValue = result.mapOrElse((e) => -1, (x) => x);
      expect(futureValue, completion(0));
    });

    test('Error', () async {
      final result = Future.value(Err(0));
      final futureValue = result.mapOrElse((e) => e, (x) => x);
      expect(futureValue, completion(0));
    });
  });

  group('unwrapOrNull and unwrapErrOrNull', () {
    test('Ok', () async {
      final result = Future.value(const Ok(0));

      expect(result.isOk(), completion(true));
      expect(result.unwrapOrNull(), completion(0));
    });

    test('Error', () async {
      final result = Future.value(Err(0));

      expect(result.isErr(), completion(true));
      expect(result.unwrapErr(), completion(0));
    });
  });

  group('unwrap', () {
    test('Ok', () {
      final result = Future.value(const Ok(0));
      expect(result.unwrap(), completion(0));
    });

    test('Error', () {
      final result = Future.value(Err(0));
      expect(result.unwrap, throwsA(isA<Panic>()));
    });
  });

  group('unwrapOrElse', () {
    test('Ok', () {
      final result = Future.value(const Ok(0));
      final value = result.unwrapOrElse((f) => -1);
      expect(value, completion(0));
    });

    test('Error', () {
      final result = Future.value(Err(0));
      final value = result.unwrapOrElse((f) => 2);
      expect(value, completion(2));
    });
  });

  group('unwrapOr', () {
    test('Ok', () {
      final result = Future.value(const Ok(0));
      final value = result.unwrapOr(-1);
      expect(value, completion(0));
    });

    test('Error', () {
      final result = Future.value(Err(0));
      final value = result.unwrapOr(2);
      expect(value, completion(2));
    });
  });

  group('inspect', () {
    test('Ok', () {
      Future.value(const Ok(0)).inspectErr((error) {}).inspect(
        expectAsync1(
          (value) {
            expect(value, 0);
          },
        ),
      );
    });

    test('Error', () {
      Future.value(Err('error')).inspect((ok) {}).inspectErr(
        expectAsync1(
          (value) {
            expect(value, 'error');
          },
        ),
      );
    });
  });

  group('isOkAnd', () {
    test('Ok', () {
      final result = Future.value(const Ok(0));
      final futureValue = result.isOkAnd((x) => x == 0);
      expect(futureValue, completion(true));
    });

    test('Error', () {
      final result = Future.value(Err(0));
      final futureValue = result.isOkAnd((x) => x == 0);
      expect(futureValue, completion(false));
    });
  });

  //************************************************************************//

  test('transpose Future Result Null', () async {
    FutureResult<String?, int> x = Future.value(Ok(null));
    expect((await x.transpose()), null);
    x = Future.value(Ok(""));
    expect((await x.transpose())?.unwrap(), "");
  });

  test('transpose Future Null Result', () async {
    Future<Result<String, int>?> x = Future.value(null);
    expect((await x).transposeIn().unwrap(), null);
    FutureResult<String?, int> y = Future.value(Ok<String?, int>(""));
    expect((await y.transpose())?.unwrap(), "");
  });

  //************************************************************************//

  group("Early Return", () {
    FutureResult<int, String> earlyReturnErr() => Result.async(($) {
          return Future.value(Err("return error"));
        });
    FutureResult<int, String> earlyReturnOk() => Result.async(($) {
          return Future.value(Ok(2));
        });
    FutureResult<int, String> regularOk() async {
      return Ok(1);
    }

    FutureResult<int, String> regularErr() async {
      return Err("message");
    }

    FutureResult<int, int> wrongType() async {
      return Ok(1);
    }

    test('No Exit', () async {
      FutureResult<int, String> add3(int val) {
        return Result.async(($) async {
          int x = await regularOk()[$];
          int y = Ok(1)[$];
          int z = Ok(1).mapErr((err) => err.toString())[$];
          return Ok(val + x + y + z);
        });
      }

      expect(await add3(2).unwrap(), 5);
    });

    test('No Exit 2', () async {
      FutureResult<int, String> add3(int val) {
        return Result.async(($) async {
          int x = await earlyReturnOk()[$];
          int y = Ok(1)[$];
          int z = Ok(1).mapErr((err) => err.toString())[$];
          return Ok(val + x + y + z);
        });
      }

      expect(await add3(2).unwrap(), 6);
    });

    test('With Exit', () async {
      FutureResult<int, String> testDoNotation() => Result.async(($) async {
            int y = Ok(1)[$];
            int z = Ok(1).mapErr((err) => err.toString())[$];
            int x = await regularErr()[$];
            return Ok(x + y + z);
          });
      expect(await testDoNotation().unwrapErr(), "message");
    });

    test('With Exit 2', () async {
      FutureResult<int, String> testDoNotation() => Result.async(($) async {
            int y = Ok(1)[$];
            int z = Ok(1).mapErr((err) => err.toString())[$];
            int x = await earlyReturnErr()[$];
            return Ok(x + y + z);
          });
      expect(await testDoNotation().unwrapErr(), "return error");
    });

    test('With Return Err', () async {
      expect(await earlyReturnErr().unwrapErr(), "return error");
    });

    test('Normal Ok', () async {
      FutureResult<int, String> testDoNotation() => Result.async(($) async {
            int y = 3;
            int z = 2;
            int x = 1;
            return Ok(x + y + z);
          });
      expect(await testDoNotation().unwrap(), 6);
    });

    test('Normal Err', () async {
      FutureResult<int, String> testDoNotation() => Result.async(($) async {
            int y = 3;
            int z = 2;
            int x = 1;
            return Err("${x + y + z}");
          });
      expect(await testDoNotation().unwrapErr(), "6");
    });

    test('Wrong type', () async {
      FutureResult<int, String> testDoNotation() => Result.async(($) {
            // wrongType()[$]; // does not compile as expected
            wrongType();
            return Future.value(Err(""));
          });
      expect(await testDoNotation().unwrapErr(), "");
    });

    test("Async-Sync does not cross boundaries", () async {
      FutureResult<int, String> testAsyncSync() => Result.async(($) {
            final Result<int, String> x = Result<int, String>(($2) {
              return Ok(Err<int, String>("1")[$]);
            });
            expect(x.unwrapErr(), "1");
            return Future.value(Ok(1));
          });
      expect(await testAsyncSync().unwrap(), 1);

      late Result<int, String> inner;
      Result<int, String> testSyncAsync() => Result(($) {
            final FutureResult<int, String> _ = Result.async<int, String>(($2) {
              return Future.value(Ok(Err<int, String>("1")[$]));
            }).then((value) {
              inner = value;
              return value;
            });
            return Ok(1);
          });
      expect(testSyncAsync().unwrap(), 1);
      await Future.delayed(Duration(milliseconds: 200));
      expect(inner.unwrapErr(), "1");
    });
  });
}
