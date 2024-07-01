import 'dart:async';

import 'package:rust_core/convert.dart';
import 'package:rust_core/panic.dart';
import 'package:rust_core/option.dart';
import 'package:rust_core/iter.dart';

part 'future_result.dart';

/// {@template result}
/// [Result] class representing the type union between [Ok] and [Err].
///
/// [S] is the ok type (aka success) and [F] is an error (aka failure).
/// {@endtemplate}
sealed class Result<S, F extends Object> {
  /// Creates a context for early return, similar to "Do notation".
  /// Here "$" is used as the "Early Return Key". when "$" is used on a type [Err],
  /// immediately the context that "$" belongs to is returned with that [Err].
  /// Works like the Rust "?" operator, which is a "Early Return Operator".
  /// e.g.
  /// ```dart
  ///     Result<int,String> innerFn() => Err("message");
  ///
  ///     Result<int, String> innerFn2() => Ok(1);
  ///
  ///     Result<int, String> earlyReturn() => Result(($) {
  ///         int y = 2;
  ///         int x = innerFn()[$]; // returns [Err] here immediately
  ///         int z = innerFn2()[$]; // innerFn2 will not be executed
  ///         return Ok(x + y + z);
  ///       });
  ///     }
  ///     expect(earlyReturn().unwrapErr(), "message");
  ///```
  /// This should be used at the top level of a function as above. Passing "$" to any other functions, nesting, or
  /// attempting to bring "$" out of the original scope should be avoided.
  @pragma("vm:prefer-inline")
  factory Result(_ResultEarlyReturnFunction<S, F> fn) {
    try {
      return fn(_ResultEarlyReturnKey<F>._());
    } on _ResultEarlyReturnNotification<F> catch (notification) {
      return notification.value;
    }
  }

  /// Creates a async context for early return, similar to "Do notation".
  /// Here "$" is used as the "Early Return Key". when "$" is used on a type [Err],
  /// immediately the context that "$" belongs to is returned with that [Err].
  /// Works like the Rust "?" operator, which is a "Early Return Operator".
  /// e.g.
  ///
  /// ```dart
  ///     FutureResult<int,String> innerFn() async => Err("message");
  ///
  ///     FutureResult<int, String> innerFn2() async => Ok(1);
  ///
  ///     FutureResult<int, String> earlyReturn() => Result.early(($) async {
  ///         int y = 2;
  ///         int x = await innerFn()[$]; // returns [Err] here immediately
  ///         int z = await innerFn2()[$]; // innerFn2 will not be executed
  ///         return Ok(x + y + z);
  ///       });
  ///     }
  ///     expect(await earlyReturn().unwrapErr(), "message");
  ///```
  ///
  /// This should be used at the top level of a function as above. Passing "$" to any other functions, nesting, or
  /// attempting to bring "$" out of the original scope should be avoided.
  @pragma("vm:prefer-inline")
  static Future<Result<S, F>> async<S, F extends Object>(
    // ignore: library_private_types_in_public_api
    _AsyncResultEarlyReturnFunction<S, F> fn,
  ) async {
    try {
      return await fn(_ResultEarlyReturnKey._());
    } on _ResultEarlyReturnNotification<F> catch (notification) {
      return notification.value;
    }
  }

  /// Returns the ok value if [Result] is [Ok].
  /// Throws a [Panic] if the [Result] is [Err].
  S unwrap();

  /// Returns the encapsulated value if this instance represents
  /// [Ok] or the [defaultValue] if it is [Err].
  /// Note: This should not be used to determine is [Ok] or is [Err], since when the success type is nullable, a
  /// default value of null can be provided, which is ambiguous in meaning.
  S unwrapOr(S defaultValue);

  /// Returns the encapsulated value if this instance represents [Ok]
  /// or the result of [onError] function for
  /// the encapsulated a [Err] value.
  /// Note: This should not be used to determine is [Ok] or is [Err], since when the success type is nullable,
  /// the value returned can be null, which is ambiguous in meaning.
  S unwrapOrElse(S Function(F error) onError);

  /// Returns the value of [Ok] or null.
  /// Note: This should not be used to determine is [Ok] or is [Err], since when the success type is nullable, a
  /// null is ambiguous in meaning.
  S? unwrapOrNull();

  /// Converts a [Result] into an Option, returning [Some] if the [Result] is [Ok], and [_None] if the [Result] is [Err].
  /// Note: This should not be used to determine is [Ok] or is [Err], since when the success type is nullable, a
  /// null is ambiguous in meaning.
  Option<S> unwrapOrOption();

  /// Returns the err value if [Result] is [Err].
  /// Throws a [Panic] if the [Result] is [Ok].
  F unwrapErr();

  /// Returns the ok value if [Result] is [Ok].
  /// Throws a [Panic] if the [Result] is [Err], with the provided [message].
  S expect(String message);

  /// Returns the err value if [Result] is [Err].
  /// Throws a [Panic] if the [Result] is [Ok], with the provided [message].
  F expectErr(String message);

  //************************************************************************//

  /// Returns true if the current result is an [Err].
  bool isErr();

  /// Returns true if the result is [Err] and the value inside of it matches a predicate.
  bool isErrAnd(bool Function(F) fn);

  /// Returns true if the current result is a [Ok].
  bool isOk();

  /// Returns true if the result is [Ok] and the value inside of it matches a predicate.
  bool isOkAnd(bool Function(S) fn);

  //************************************************************************//

  /// Returns an iterable over the possibly contained value. The iterator yields one value if the result is
  /// [Ok], otherwise none.
  RIterator<S> iter();

  //************************************************************************//

  /// Performs an "and" operation on the results. Returns the
  /// first result that is [Err], otherwise if both are [Ok], other [Ok] Result is returned.
  Result<S2, F> and<S2>(Result<S2, F> other);

  /// Performs an "or" operation on the results. Returns the first [Ok] value, if neither are [Ok], returns
  /// the other [Err].
  Result<S, F2> or<F2 extends Object>(Result<S, F2> other);

  /// Calls [fn] if the result is [Err], otherwise returns the [Ok] value of this.
  Result<S, F2> orElse<F2 extends Object>(Result<S, F2> Function(F) fn);

  //************************************************************************//

  /// Returns the result of [ok] for the encapsulated value
  /// if this instance represents [Ok] or the result of [err] function
  /// for the encapsulated value if it is [Err].
  W match<W>({required W Function(S) ok, required W Function(F) err});

  /// Returns a new [Result], mapping any [Ok] value
  /// using the given transformation.
  Result<W, F> map<W>(W Function(S ok) fn);

  /// Returns the provided default (if [Err]), or applies a function to the contained value (if [Ok]).
  W mapOr<W>(W defaultValue, W Function(S ok) fn);

  /// Evaluates the provided [defaultFn] (if [Err]), or applies a function to the contained value (if [Ok]).
  W mapOrElse<W>(W Function(F err) defaultFn, W Function(S ok) fn);

  /// Returns a new [Result], mapping any [Err] value
  /// using the given transformation.
  Result<S, W> mapErr<W extends Object>(W Function(F error) fn);

  /// If [Ok], Returns a new [Result] by passing the [Ok] value
  /// to the provided function.
  Result<W, F> andThen<W>(Result<W, F> Function(S ok) fn);

  //// If [Err], Returns a new [Result] by passing the [Err] value
  /// to the provided function.
  Result<S, W> andThenErr<W extends Object>(Result<S, W> Function(F error) fn);

  /// If [Ok], Calls the provided closure with the ok value, else does nothing.
  Result<S, F> inspect(void Function(S ok) fn);

  /// If [Err], Calls the provided closure with the err value, else does nothing.
  Result<S, F> inspectErr(void Function(F error) fn);

  //************************************************************************//

  /// Performs a shallow copy of this result.
  Result<S, F> copy();

  /// Changes the [Ok] type to [S2]. See [into] for a safe implementation of [intoUnchecked]. This is usually used
  /// when "this" is known to be an [Err] and you want to return to
  /// the calling function, but the returning function's [Ok] type is different from this [Ok] type.
  ///
  /// Throws an [Error] if cannot cast the [Ok] value to [S2].
  /// Example of proper use:
  /// ```dart
  /// Result<int,String> someFunction1 () {...}
  ///
  /// Result<String,String> someFunction2() {
  ///   Result<int,String> result = someFunction1();
  ///   if (result.isErr()) {
  ///     return result.intoUnchecked();
  ///   }
  /// ...
  ///```
  /// Note how above, the [S2] value is inferred by Dart, this is usually what be want rather than being explicit.
  /// In Rust, "intoUnchecked" is handled by the "?" operator, but there is no equivalent in Dart.
  Result<S2, F> intoUnchecked<S2>();

  //************************************************************************//

  /// Functions an "Early Return Operator" when given an "Early Return key" "$". See [Result.$] for more information.
  // ignore: library_private_types_in_public_api
  S operator [](_ResultEarlyReturnKey<F> op);
}

/// {@template ok}
/// Ok Result.
///
/// Returned when the result is an expected value
/// {@endtemplate}
final class Ok<S, F extends Object> implements Result<S, F> {
  /// Receives the [S] param as
  /// the ok result.
  const Ok(
    this.ok,
  );

  final S ok;

  //************************************************************************//

  @override
  @pragma("vm:prefer-inline")
  S unwrap() {
    return ok;
  }

  @override
  @pragma("vm:prefer-inline")
  S unwrapOr(S defaultValue) => ok;

  @override
  @pragma("vm:prefer-inline")
  S unwrapOrElse(S Function(F error) onError) {
    return ok;
  }

  @override
  @pragma("vm:prefer-inline")
  S unwrapOrNull() => ok;

  @override
  @pragma("vm:prefer-inline")
  Some<S> unwrapOrOption() => Some(ok);

  @override
  @pragma("vm:prefer-inline")
  F unwrapErr() {
    throw Panic("Called `unwrapErr` on an `$runtimeType` of `$ok`.");
  }

  @override
  @pragma("vm:prefer-inline")
  S expect(String message) {
    return ok;
  }

  @override
  @pragma("vm:prefer-inline")
  F expectErr(String message) {
    throw Panic("Called `expectErr` on an `$runtimeType` of `$ok`. $message");
  }

  //************************************************************************//

  @override
  @pragma("vm:prefer-inline")
  bool isErr() => false;

  @override
  @pragma("vm:prefer-inline")
  bool isErrAnd(bool Function(F) fn) => false;

  @override
  @pragma("vm:prefer-inline")
  bool isOk() => true;

  @override
  @pragma("vm:prefer-inline")
  bool isOkAnd(bool Function(S) fn) => fn(ok);

  //************************************************************************//

  @override
  @pragma("vm:prefer-inline")
  RIterator<S> iter() {
    return RIterator([ok].iterator);
  }

  //************************************************************************//

  @override
  @pragma("vm:prefer-inline")
  Result<S2, F> and<S2>(Result<S2, F> other) {
    return other;
  }

  @override
  @pragma("vm:prefer-inline")
  Result<S, F2> or<F2 extends Object>(Result<S, F2> other) {
    return into();
  }

  @override
  @pragma("vm:prefer-inline")
  Result<S, F2> orElse<F2 extends Object>(Result<S, F2> Function(F) fn) {
    return into();
  }

  //************************************************************************//

  @override
  @pragma("vm:prefer-inline")
  W match<W>({required W Function(S) ok, required W Function(F) err}) {
    return ok(this.ok);
  }

  @override
  @pragma("vm:prefer-inline")
  Ok<W, F> map<W>(W Function(S ok) fn) {
    final newOk = fn(ok);
    return Ok<W, F>(newOk);
  }

  @override
  @pragma("vm:prefer-inline")
  W mapOr<W>(W defaultValue, W Function(S ok) fn) {
    return fn(ok);
  }

  @override
  @pragma("vm:prefer-inline")
  W mapOrElse<W>(W Function(F err) defaultFn, W Function(S ok) fn) {
    return fn(ok);
  }

  @override
  @pragma("vm:prefer-inline")
  Ok<S, W> mapErr<W extends Object>(W Function(F error) fn) {
    return Ok<S, W>(ok);
  }

  @override
  @pragma("vm:prefer-inline")
  Result<W, F> andThen<W>(Result<W, F> Function(S ok) fn) {
    return fn(ok);
  }

  @override
  @pragma("vm:prefer-inline")
  Ok<S, W> andThenErr<W extends Object>(
    Result<S, W> Function(F error) fn,
  ) {
    return Ok<S, W>(ok);
  }

  @override
  @pragma("vm:prefer-inline")
  Ok<S, F> inspect(void Function(S ok) fn) {
    fn(ok);
    return this;
  }

  @override
  @pragma("vm:prefer-inline")
  Ok<S, F> inspectErr(void Function(F error) fn) {
    return this;
  }

  //************************************************************************//

  @override
  @pragma("vm:prefer-inline")
  Ok<S, F> copy() {
    return Ok(ok);
  }

  @override
  @pragma("vm:prefer-inline")
  Ok<S2, F> intoUnchecked<S2>() {
    return Ok(ok as S2);
  }

  /// Changes the [Err] type to [F2]. This is usually used when "this" is known to be an [Ok] and you want to return to
  /// the calling function, but the returning function's [F] type is different from this [F] type.
  ///
  /// Note: This function should almost never be used, since if the calling function expects a [Result], then calling
  /// functions [F] type should be a super type of this [F] type. [into] is usually only useful for this is known to
  /// be an error
  @pragma("vm:prefer-inline")
  Ok<S, F2> into<F2 extends Object>() {
    return Ok(ok);
  }

  //************************************************************************//

  @override
  @pragma("vm:prefer-inline")
  // ignore: library_private_types_in_public_api
  S operator [](_ResultEarlyReturnKey<F> op) {
    return ok;
  }

  //************************************************************************//

  @override
  int get hashCode => ok.hashCode;

  @override
  bool operator ==(Object other) {
    return other is Ok && other.ok == ok;
  }

  @override
  String toString() {
    return "$ok";
  }
}

/// {@template err}
/// Error Result.
///
/// Returned when the result is an unexpected value
/// {@endtemplate}
final class Err<S, F extends Object> implements Result<S, F> {
  /// Receives the [F] param as
  /// the error result.
  const Err(this.err);

  final F err;

  //************************************************************************//

  @override
  @pragma("vm:prefer-inline")
  S unwrap() {
    throw Panic("Called `unwrap` on an `$runtimeType` of `$err`.");
  }

  @override
  @pragma("vm:prefer-inline")
  S unwrapOr(S defaultValue) => defaultValue;

  @override
  @pragma("vm:prefer-inline")
  S unwrapOrElse(S Function(F error) onError) {
    return onError(err);
  }

  @override
  @pragma("vm:prefer-inline")
  S? unwrapOrNull() => null;

  @override
  @pragma("vm:prefer-inline")
  Option<S> unwrapOrOption() => None;

  @override
  @pragma("vm:prefer-inline")
  F unwrapErr() {
    return err;
  }

  @override
  @pragma("vm:prefer-inline")
  S expect(String message) {
    throw Panic("Called `expect` on an `$runtimeType` of `$err`. $message");
  }

  @override
  @pragma("vm:prefer-inline")
  F expectErr(String message) {
    return err;
  }

  //************************************************************************//

  @override
  @pragma("vm:prefer-inline")
  bool isErr() => true;

  @override
  @pragma("vm:prefer-inline")
  bool isErrAnd(bool Function(F) fn) => fn(err);

  @override
  @pragma("vm:prefer-inline")
  bool isOk() => false;

  @override
  @pragma("vm:prefer-inline")
  bool isOkAnd(bool Function(S) fn) => false;

  //************************************************************************//

  @override
  @pragma("vm:prefer-inline")
  RIterator<S> iter() {
    return RIterator(<S>[].iterator);
  }

  //************************************************************************//

  @override
  @pragma("vm:prefer-inline")
  Result<S2, F> and<S2>(Result<S2, F> other) {
    return into();
  }

  @override
  @pragma("vm:prefer-inline")
  Result<S, F2> or<F2 extends Object>(Result<S, F2> other) {
    return other;
  }

  @override
  @pragma("vm:prefer-inline")
  Result<S, F2> orElse<F2 extends Object>(Result<S, F2> Function(F) fn) {
    return fn(err);
  }

  //************************************************************************//

  @override
  @pragma("vm:prefer-inline")
  W match<W>({required W Function(S) ok, required W Function(F) err}) {
    return err(this.err);
  }

  @override
  @pragma("vm:prefer-inline")
  Err<W, F> map<W>(W Function(S ok) fn) {
    return Err<W, F>(err);
  }

  @override
  @pragma("vm:prefer-inline")
  W mapOr<W>(W defaultValue, W Function(S ok) fn) {
    return defaultValue;
  }

  @override
  @pragma("vm:prefer-inline")
  W mapOrElse<W>(W Function(F err) defaultFn, W Function(S ok) fn) {
    return defaultFn(err);
  }

  @override
  @pragma("vm:prefer-inline")
  Err<S, W> mapErr<W extends Object>(W Function(F error) fn) {
    final newError = fn(err);
    return Err(newError);
  }

  @override
  @pragma("vm:prefer-inline")
  Result<W, F> andThen<W>(Result<W, F> Function(S ok) fn) {
    return Err<W, F>(err);
  }

  @override
  @pragma("vm:prefer-inline")
  Result<S, W> andThenErr<W extends Object>(
    Result<S, W> Function(F error) fn,
  ) {
    return fn(err);
  }

  @override
  @pragma("vm:prefer-inline")
  Err<S, F> inspect(void Function(S ok) fn) {
    return this;
  }

  @override
  @pragma("vm:prefer-inline")
  Err<S, F> inspectErr(void Function(F error) fn) {
    fn(err);
    return this;
  }

  //************************************************************************//

  @override
  @pragma("vm:prefer-inline")
  Err<S, F> copy() {
    return Err(err);
  }

  @override
  @pragma("vm:prefer-inline")
  Err<S2, F> intoUnchecked<S2>() {
    return Err(err);
  }

  /// Changes the [Ok] type to [S2]. This is usually used when "this" is known to be an [Err] and you want to return to
  /// the calling function, but the returning function's [S] type is different from this [S] type.
  ///
  /// Example of proper use:
  /// ```dart
  /// Result<int,String> someFunction1 () {...}
  ///
  /// Result<String,String> someFunction2() {
  ///   Result<int,String> result = someFunction1();
  ///   if (result case Err()) {
  ///     return result.into();
  ///   }
  /// ...
  ///```
  /// Note how above, the [S2] value is inferred by Dart, this is usually what be want rather than being explicit.
  /// Note: In Rust, "into" is handled by the "?" operator, but there is no equivalent in Dart.
  @pragma("vm:prefer-inline")
  Err<S2, F> into<S2>() {
    return Err(err);
  }

  //************************************************************************//

  @override
  @pragma("vm:prefer-inline")
  // ignore: library_private_types_in_public_api
  S operator [](_ResultEarlyReturnKey<F> op) {
    throw _ResultEarlyReturnNotification(this.into());
  }

  //************************************************************************//

  @override
  int get hashCode => err.hashCode;

  @override
  bool operator ==(Object other) => other is Err && other.err == err;

  @override
  String toString() {
    return "$err";
  }
}

//************************************************************************//

/// The key that allows early returns for [Result]. The key to the lock.
final class _ResultEarlyReturnKey<F extends Object> {
  const _ResultEarlyReturnKey._();
}

/// Thrown from a do notation context
final class _ResultEarlyReturnNotification<F extends Object> {
  final Err<Infallible, F> value;

  const _ResultEarlyReturnNotification(this.value);
}

typedef _ResultEarlyReturnFunction<S, F extends Object> = Result<S, F> Function(
    _ResultEarlyReturnKey<F>);

typedef _AsyncResultEarlyReturnFunction<S, F extends Object>
    = Future<Result<S, F>> Function(_ResultEarlyReturnKey<F>);
