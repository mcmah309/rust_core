part of 'result.dart';

/// {@macro futureResult}
typedef FutureResult<S, F extends Object> = Future<Result<S, F>>;

/// {@template futureResult}
/// [FutureResult] represents an asynchronous [Result]. And as such, inherits all of [Result]s methods.
/// {@endtemplate}
extension FutureResultExtension<S, F extends Object> on FutureResult<S, F> {
  @pragma("vm:prefer-inline")
  Future<S> unwrap() {
    return then((result) => result.unwrap());
  }

  @pragma("vm:prefer-inline")
  Future<S> unwrapOr(S defaultValue) {
    return then((result) => result.unwrapOr(defaultValue));
  }

  @pragma("vm:prefer-inline")
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

  @pragma("vm:prefer-inline")
  Future<S?> unwrapOrNull() {
    return then((result) => result.unwrapOrNull());
  }

  @pragma("vm:prefer-inline")
  Future<Option<S>> unwrapOrOption() async {
    return then((result) => result.unwrapOrOption());
  }

  @pragma("vm:prefer-inline")
  Future<F> unwrapErr() {
    return then((result) => result.unwrapErr());
  }

  @pragma("vm:prefer-inline")
  Future<S> expect(String message) {
    return then((result) => result.expect(message));
  }

  @pragma("vm:prefer-inline")
  Future<F> expectErr(String message) {
    return then((result) => result.expectErr(message));
  }

  //************************************************************************//

  @pragma("vm:prefer-inline")
  Future<bool> isErr() {
    return then((result) => result.isErr());
  }

  @pragma("vm:prefer-inline")
  Future<bool> isErrAnd(FutureOr<bool> Function(F) fn) {
    return then((result) {
      if (result.isErr()) {
        return fn(result.unwrapErr());
      } else {
        return false;
      }
    });
  }

  @pragma("vm:prefer-inline")
  Future<bool> isOk() {
    return then((result) => result.isOk());
  }

  @pragma("vm:prefer-inline")
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

  @pragma("vm:prefer-inline")
  Future<Iter<S>> iter() {
    return then((result) => result.iter());
  }

  //************************************************************************//

  @pragma("vm:prefer-inline")
  FutureResult<S2, F> and<S2>(Result<S2, F> other) {
    return then((result) => result.and(other));
  }

  @pragma("vm:prefer-inline")
  FutureResult<S, F2> or<F2 extends Object>(Result<S, F2> other) {
    return then((result) => result.or(other));
  }

  @pragma("vm:prefer-inline")
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

  @pragma("vm:prefer-inline")
  Future<W> match<W>(
      {required FutureOr<W> Function(S) ok,
      required FutureOr<W> Function(F) err}) {
    return then<W>((result) => result.match(ok: ok, err: err));
  }

  @pragma("vm:prefer-inline")
  FutureResult<W, F> map<W>(FutureOr<W> Function(S ok) fn) {
    return mapOrElse(
      Err.new,
      (ok) async {
        return Ok(await fn(ok));
      },
    );
  }

  @pragma("vm:prefer-inline")
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

  @pragma("vm:prefer-inline")
  Future<W> mapOrElse<W>(
      FutureOr<W> Function(F err) defaultFn, FutureOr<W> Function(S ok) fn) {
    return then<W>((result) => result.mapOrElse(defaultFn, fn));
  }

  @pragma("vm:prefer-inline")
  FutureResult<S, W> mapErr<W extends Object>(
      FutureOr<W> Function(F error) fn) {
    return mapOrElse(
      (error) async {
        return Err(await fn(error));
      },
      Ok.new,
    );
  }

  @pragma("vm:prefer-inline")
  FutureResult<W, F> andThen<W>(FutureOr<Result<W, F>> Function(S ok) fn) {
    return mapOrElse(Err.new, fn);
  }

  @pragma("vm:prefer-inline")
  FutureResult<S, W> andThenErr<W extends Object>(
      FutureOr<Result<S, W>> Function(F error) fn) {
    return mapOrElse(fn, Ok.new);
  }

  @pragma("vm:prefer-inline")
  FutureResult<S, F> inspect(FutureOr<void> Function(S ok) fn) {
    return then((result) => result.inspect(fn));
  }

  @pragma("vm:prefer-inline")
  FutureResult<S, F> inspectErr(FutureOr<void> Function(F error) fn) {
    return then((result) => result.inspectErr(fn));
  }

  //************************************************************************//

  @pragma("vm:prefer-inline")
  FutureResult<S, F> copy() {
    return then((result) => result.copy());
  }

  @pragma("vm:prefer-inline")
  FutureResult<S2, F> intoUnchecked<S2>() {
    return then((value) => value.intoUnchecked<S2>());
  }

  //************************************************************************//

  @pragma("vm:prefer-inline")
  // ignore: library_private_types_in_public_api
  Future<S> operator [](_ResultEarlyReturnKey<F> op) {
    return then((value) => value[op]);
  }
}
