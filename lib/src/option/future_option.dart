part of 'option.dart';

/// {@macro futureOption}
typedef FutureOption<T> = Future<Option<T>>;

/// {@template futureOption}
/// [FutureOption] represents an asynchronous [Option]. And as such, inherits all of [Option]'s methods.
/// {@endtemplate}
extension FutureOptionExtension<T> on FutureOption<T> {
  Future<Option<U>> and<U>(Option<U> other) {
    return then((option) => option.and(other));
  }

  Future<Option<U>> andThen<U>(FutureOr<Option<U>> Function(T) f) {
    return then((option) =>
        option.isSome() ? f(option.unwrap()) : Future.value(const None()));
  }

  Future<T> expect(String msg) {
    return then((option) => option.expect(msg));
  }

  Future<Option<T>> filter(FutureOr<bool> Function(T) predicate) {
    return then((option) async =>
        option.isSome() && (await predicate(option.unwrap()))
            ? option
            : const None());
  }

  Future<Option<T>> inspect(FutureOr<void> Function(T) f) {
    return then((option) => option.inspect(f));
  }

  Future<bool> isNone() {
    return then((option) => option.isNone());
  }

  Future<bool> isSome() {
    return then((option) => option.isSome());
  }

  Future<bool> isSomeAnd(FutureOr<bool> Function(T) f) {
    return then((option) async => option.isSome() && await f(option.unwrap()));
  }

  Future<Iterable<T>> iter() {
    return then((option) => option.iter());
  }

  Future<Option<U>> map<U>(U Function(T) f) {
    return then((option) => option.map(f));
  }

  Future<U> mapOr<U>(U defaultValue, U Function(T) f) {
    return then(
        (option) => option.isSome() ? f(option.unwrap()) : defaultValue);
  }

  Future<U> mapOrElse<U>(U Function() defaultFn, U Function(T) f) {
    return then((option) => option.isSome() ? f(option.unwrap()) : defaultFn());
  }

  Future<Result<T, E>> okOr<E extends Object>(E err) {
    return then((option) => option.okOr(err));
  }

  Future<Result<T, E>> okOrElse<E extends Object>(E Function() errFn) {
    return then((option) => option.okOrElse(errFn));
  }

  Future<Option<T>> or(Option<T> other) {
    return then((option) => option.isNone() ? other : option);
  }

  Future<Option<T>> orElse(Option<T> Function() f) {
    return then((option) => option.isNone() ? f() : option);
  }

  Future<T> unwrap() {
    return then((option) => option.unwrap());
  }

  Future<T> unwrapOr(T defaultValue) {
    return then((option) => option.unwrapOr(defaultValue));
  }

  Future<T> unwrapOrElse(T Function() f) {
    return then((option) => option.unwrapOrElse(f));
  }

  Future<Option<T>> xor(Option<T> other) {
    return then((option) => option.xor(other));
  }

  Future<Option<(T, U)>> zip<U>(Option<U> other) {
    return then((option) => option.zip(other));
  }

  Future<Option<R>> zipWith<U, R>(Option<U> other, R Function(T, U) f) {
    return then((option) => option.zipWith(other, f));
  }

  //************************************************************************//

  Future<T?> toNullable() {
    return then((option) => option.toNullable());
  }

  //************************************************************************//

  // ignore: library_private_types_in_public_api
  Future<T> operator [](_OptionEarlyReturnKey op) {
    return then((value) => value[op]);
  }
}
