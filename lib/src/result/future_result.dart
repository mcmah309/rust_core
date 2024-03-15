part of 'result.dart';

/// {@macro futureResult}
typedef FutureResult<S, F extends Object> = Future<Result<S, F>>;

/// {@template futureResult}
/// [FutureResult] represents an asynchronous [Result]. And as such, inherits all of [Result]s methods.
/// {@endtemplate}
extension FutureResultExtension<S, F extends Object> on FutureResult<S, F> {
  Future<S> unwrap() {
    return then((result) => result.unwrap());
  }

  Future<S> unwrapOr(S defaultValue) {
    return then((result) => result.unwrapOr(defaultValue));
  }

  Future<S> unwrapOrElse(FutureOr<S> Function(F) onError) {
    return mapOrElse(
      (err) {
        return onError(err);
      },
      (ok) {
        return ok;
      },
    );
  }

  Future<S?> unwrapOrNull() {
    return then((result) => result.unwrapOrNull());
  }

  Future<Option<S>> unwrapOrOption() async {
    return then((result) => result.unwrapOrOption());
  }

  Future<F> unwrapErr() {
    return then((result) => result.unwrapErr());
  }

  Future<S> expect(String message) {
    return then((result) => result.expect(message));
  }

  Future<F> expectErr(String message) {
    return then((result) => result.expectErr(message));
  }

  //************************************************************************//

  Future<bool> isErr() {
    return then((result) => result.isErr());
  }

  Future<bool> isErrAnd(FutureOr<bool> Function(F) fn) {
    return then((result) {
      if (result.isErr()) {
        return fn(result.unwrapErr());
      } else {
        return false;
      }
    });
  }

  Future<bool> isOk() {
    return then((result) => result.isOk());
  }

  Future<bool> isOkAnd(FutureOr<bool> Function(S) fn) {
    return then((result) {
      if (result.isOk()) {
        return fn(result.unwrap());
      } else {
        return false;
      }
    });
  }

  //************************************************************************//

  Future<RIterator<S>> iter() {
    return then((result) => result.iter());
  }

  //************************************************************************//

  FutureResult<S2, F> and<S2>(Result<S2, F> other) {
    return then((result) => result.and(other));
  }

  FutureResult<S, F2> or<F2 extends Object>(Result<S, F2> other) {
    return then((result) => result.or(other));
  }

  FutureResult<S, F2> orElse<F2 extends Object>(
      FutureOr<Result<S, F2>> Function(F) fn) {
    return mapOrElse(
      (error) {
        return fn(error);
      },
      Ok.new,
    );
  }

  //************************************************************************//

  Future<W> match<W>(
      {required FutureOr<W> Function(S) ok,
      required FutureOr<W> Function(F) err}) {
    return then<W>((result) => result.match(ok: ok, err: err));
  }

  FutureResult<W, F> map<W>(FutureOr<W> Function(S ok) fn) {
    return mapOrElse(
      Err.new,
      (ok) async {
        return Ok(await fn(ok));
      },
    );
  }

  Future<W> mapOr<W>(W defaultValue, FutureOr<W> Function(S ok) fn) {
    return mapOrElse(
      (error) {
        return defaultValue;
      },
      (ok) {
        return fn(ok);
      },
    );
  }

  Future<W> mapOrElse<W>(
      FutureOr<W> Function(F err) defaultFn, FutureOr<W> Function(S ok) fn) {
    return then<W>((result) => result.mapOrElse(defaultFn, fn));
  }

  FutureResult<S, W> mapErr<W extends Object>(
      FutureOr<W> Function(F error) fn) {
    return mapOrElse(
      (error) async {
        return Err(await fn(error));
      },
      Ok.new,
    );
  }

  FutureResult<W, F> andThen<W>(FutureOr<Result<W, F>> Function(S ok) fn) {
    return mapOrElse(Err.new, fn);
  }

  FutureResult<S, W> andThenErr<W extends Object>(
      FutureOr<Result<S, W>> Function(F error) fn) {
    return mapOrElse(fn, Ok.new);
  }

  FutureResult<S, F> inspect(FutureOr<void> Function(S ok) fn) {
    return then((result) => result.inspect(fn));
  }

  FutureResult<S, F> inspectErr(FutureOr<void> Function(F error) fn) {
    return then((result) => result.inspectErr(fn));
  }

  //************************************************************************//

  FutureResult<S, F> copy() {
    return then((result) => result.copy());
  }

  FutureResult<S2, F> intoUnchecked<S2>() {
    return then((value) => value.intoUnchecked<S2>());
  }

  //************************************************************************//

  // ignore: library_private_types_in_public_api
  Future<S> operator [](_ResultEarlyReturnKey<F> op) {
    return then((value) => value[op]);
  }
}
