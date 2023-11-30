import '../../rust_core.dart';

/// The error type for errors that can never happen
typedef Infallible = Never;

extension InfallibleOkExtension<S> on Result<S, Infallible> {
  S intoOk() {
    return unwrap();
  }
}

extension InfallibleErrExtension<F extends Object> on Result<Infallible, F> {
  F intoErr() {
    return unwrapErr();
  }
}

extension InfallibleFutureOkExtension<S> on FutureResult<S, Infallible> {
  Future<S> intoOk() {
    return then((result) => result.intoOk());
  }
}

extension InfallibleFutureErrExtension<F extends Object>
    on FutureResult<Infallible, F> {
  Future<F> intoErr() {
    return then((result) => result.intoErr());
  }
}
