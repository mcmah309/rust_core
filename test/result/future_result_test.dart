
import 'package:rust_core/rust_core.dart';
import 'package:test/test.dart';

void main() {
  group('andThen', () {
    test('async ', () async {
      final result =
          await Future.value(const Ok(1)).andThen((ok) async => Ok(ok * 2));
      expect(result.unwrapOrNull(), 2);
    });

    test('sink', () async {
      final result =
          await Future.value(const Ok(1)).andThen((ok) => Ok(ok * 2));
      expect(result.unwrapOrNull(), 2);
    });
  });

  group('andThenError', () {
    test('async ', () async {
      final result = await Future.value(bail(1)).andThenErr(
          (error) async => bail(error.downcast<int>().unwrap() * 2));
      expect(result.unwrapErrOrNull()!.downcast<int>().unwrap(), 2);
    });

    test('sink', () async {
      final result = await Future.value(bail(1))
          .andThenErr((error) => bail(error.downcast<int>().unwrap() * 2));
      expect(result.unwrapErrOrNull()!.downcast<int>().unwrap(), 2);
    });
  });

  group('match', () {
    test('Ok', () async {
      final result = Future.value(const Ok(0));
      final futureValue = result.match(err: (e) => -1, ok: (x) => x);
      expect(futureValue, completion(0));
    });

    test('Error', () async {
      final result = Future.value(bail(0));
      final futureValue =
          result.match(err: (e) => e.downcast<int>().unwrap(), ok: (x) => x);
      expect(futureValue, completion(0));
    });
  });

  test('map', () async {
    final result = await Future.value(const Ok(1)).map((ok) => ok * 2);

    expect(result.unwrapOrNull(), 2);
    expect(Future.value(bail(2)).map((x) => x), completes);
  });

  test('mapErr', () async {
    final result = await Future.value(bail(1))
        .mapErr((error) => Error(error.downcast<int>().unwrap() * 2));
    expect(result.unwrapErrOrNull()!.downcast<int>().unwrap(), 2);
    expect(Future.value(const Ok(2)).mapErr((x) => x), completes);
  });

  group('mapOrElse', () {
    test('Ok', () async {
      final result = Future.value(const Ok(0));
      final futureValue = result.mapOrElse((e) => -1, (x) => x);
      expect(futureValue, completion(0));
    });

    test('Error', () async {
      final result = Future.value(bail(0));
      final futureValue =
          result.mapOrElse((e) => e.downcast<int>().unwrap(), (x) => x);
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
      final result = Future.value(bail(0));

      expect(result.isErr(), completion(true));
      expect(result.unwrapErr().downcast<int>().unwrap(), completion(0));
    });
  });

  group('unwrap', () {
    test('Ok', () {
      final result = Future.value(const Ok(0));
      expect(result.unwrap(), completion(0));
    });

    test('Error', () {
      final result = Future.value(bail(0));
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
      final result = Future.value(bail(0));
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
      final result = Future.value(bail(0));
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
      Future.value(bail('error')).inspect((ok) {}).inspectErr(
        expectAsync1(
          (value) {
            expect(value, Error('error'));
          },
        ),
      );
    });
  });
}
