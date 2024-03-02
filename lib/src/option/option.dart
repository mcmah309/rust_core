import 'dart:async';

import 'package:rust_core/result.dart';
import 'package:rust_core/panic.dart';

part 'future_option.dart';
part 'option_extensions.dart';

extension type const Option<T extends Object>._(T? v) {
  /// Creates a context for early return, similar to "Do notation". Works like the Rust "?" operator, which is a
  /// "Early Return Operator". Here "$" is used as the "Early Return Key". when "$" is used on a type [None],
  /// immediately the context that "$" belongs to is returned with None(). e.g.
  /// ```
  ///   Option<int> intNone() => const None();
  ///
  ///   Option<int> earlyReturn(int val) => Option(($){
  ///     int x = intNone()[$]; // returns [None] immediately
  ///     return Some(val + 3);
  ///   });
  ///   expect(earlyReturn(2), const None());
  ///```
  /// This should be used at the top level of a function as above. Passing "$" to any other functions, nesting, or
  /// attempting to bring "$" out of the original scope should be avoided.
  factory Option(_OptionEarlyReturnFunction<T> fn) {
    try {
      return fn(const _OptionEarlyReturnKey._());
    } on _OptionEarlyReturnNotification catch (_) {
      return const None();
    }
  }

  /// Creates a context for async early return, similar to "Do notation". Works like the Rust "?" operator, which is a
  /// "Early Return Operator". Here "$" is used as the "Early Return Key". when "$" is used on a type [None],
  /// immediately the context that "$" belongs to is returned with None(). e.g.
  /// ```
  /// FutureOption<int> intNone() async => const None();
  ///
  /// FutureOption<int> earlyReturn(int val) => Option.async(($) async {
  ///  int x = await intNone()[$]; // returns [None] immediately
  ///  return Some(x + 3);
  /// });
  /// expect(await earlyReturn(2), const None());
  ///```
  /// This should be used at the top level of a function as above. Passing "$" to any other functions, nesting, or
  /// attempting to bring "$" out of the original scope should be avoided.
  static Future<Option<T>> async<T extends Object>(
      // ignore: library_private_types_in_public_api
      _OptionAsyncEarlyReturnFunction<T> fn) async {
    try {
      return await fn(const _OptionEarlyReturnKey._());
    } on _OptionEarlyReturnNotification catch (_) {
      return Future.value(const None());
    }
  }

  /// Returns None if the option is None, otherwise returns [other].
  Option<U> and<U extends Object>(Option<U> other) {
    return this != null ? (this as Some<U>).and(other) : (this as None<U>).and(other);
  }

  ///Returns None if the option is None, otherwise calls f with the wrapped value and returns the result. Some
  ///languages call this operation flatmap.
  Option<U> andThen<U extends Object>(Option<U> Function(T) f) {
    return this != null ? (this as Some<T>).andThen(f) : (this as None<T>).andThen(f);
  }

  /// Shallow copies this Option
  Option<T> copy() {
    return this != null ? (this as Some<T>).copy() : (this as None<T>).copy();
  }

  /// Returns the contained Some value if [Some], otherwise throws a [Panic].
  T expect(String msg) {
    return this != null ? (this as Some<T>).expect(msg) : (this as None<T>).expect(msg);
  }

  /// Returns None if the option is None, otherwise calls predicate with the wrapped value and returns
  /// Some(t) if predicate returns true (where t is the wrapped value), and
  // None if predicate returns false
  Option<T> filter(bool Function(T) predicate) {
    return this is Some<T> ? (this as Some<T>).filter(predicate) : (this as None<T>).filter(predicate);
  }

  // flatten: Added as extension

  // T getOrInsert(T value); // not possible, otherwise would not be const

  // T getOrInsertWith(T Function() f); // not possible, otherwise cannot be const

  // T insert(T value); // not possible, otherwise lose const

  /// Calls the provided closure with a reference to the contained value
  Option<T> inspect(Function(T) f) {
    return this is Some<T> ? (this as Some<T>).inspect(f) : (this as None<T>).inspect(f);
  }

  /// Returns true if the option is a None value.
  bool isNone() {
    return this is Some<T> ? (this as Some<T>).isNone() : (this as None<T>).isNone();
  }

  /// Returns true if the option is a Some value.
  bool isSome() {
    return this is Some<T> ? (this as Some<T>).isSome() : (this as None<T>).isSome();
  }

  /// Returns true if the option is a Some and the value inside of it matches a predicate.
  bool isSomeAnd(bool Function(T) f) {
    return this is Some<T> ? (this as Some<T>).isSomeAnd(f) : (this as None<T>).isSomeAnd(f);
  }

  /// Returns an iterable over the possibly contained value.
  Iterable<T> iter() {
    return this is Some<T> ? (this as Some<T>).iter() : (this as None<T>).iter();
  }

  /// Maps an this Option<T> to Option<U> by applying a function to a contained value (if Some) or returns None (if
  /// None).
  Option<U> map<U extends Object>(U Function(T) f){
    return this is Some<T> ? (this as Some<T>).map(f) : (this as None<T>).map(f);
  }

  /// Returns the provided default result (if none), or applies a function to the contained value (if any).
  U mapOr<U extends Object>(U defaultValue, U Function(T) f) {
    return this is Some<T> ? (this as Some<T>).mapOr(defaultValue, f) : (this as None<T>).mapOr(defaultValue, f);
  }

  /// Computes a default function result (if none), or applies a different function to the contained value (if any).
  U mapOrElse<U extends Object>(U Function() defaultFn, U Function(T) f) {
    return this is Some<T> ? (this as Some<T>).mapOrElse(defaultFn, f) : (this as None<T>).mapOrElse(defaultFn, f);
  }

  /// Transforms the Option<T> into a Result<T, E>, mapping Some(v) to Ok(v) and None to Err(err).
  Result<T, E> okOr<E extends Object>(E err) {
    return this is Some<T> ? (this as Some<T>).okOr(err) : (this as None<T>).okOr(err);
  }

  /// Transforms the Option<T> into a Result<T, E>, mapping Some(v) to Ok(v) and None to Err(err()).
  Result<T, E> okOrElse<E extends Object>(E Function() errFn) {
    return this is Some<T> ? (this as Some<T>).okOrElse(errFn) : (this as None<T>).okOrElse(errFn);
  }

  /// Returns the option if it contains a value, otherwise returns other.
  Option<T> or(Option<T> other) {
    return this is Some<T> ? (this as Some<T>).or(other) : (this as None<T>).or(other);
  }

  /// Returns the option if it contains a value, otherwise calls f and returns the result.
  Option<T> orElse(Option<T> Function() f) {
    return this is Some<T> ? (this as Some<T>).orElse(f) : (this as None<T>).orElse(f);
  }

  // Option<T> replace(value); // not possible, otherwise not const

  // Option<T> take(); // not possible, can't transmute into None

  // Option<T> takeIf(bool Function(T) predicate); // not possible, can't transmute into None

  // transpose: Added as extension

  /// Returns the contained Some value, consuming the self value.
  T unwrap() {
    return this is Some<T> ? (this as Some<T>).unwrap() : (this as None<T>).unwrap();
  }

  /// Returns the contained Some value or a provided default.
  T unwrapOr(T defaultValue) {
    return this is Some<T> ? (this as Some<T>).unwrapOr(defaultValue) : (this as None<T>).unwrapOr(defaultValue);
  }

  /// Returns the contained Some value or computes it from a closure.
  T unwrapOrElse(T Function() f) {
    return this is Some<T> ? (this as Some<T>).unwrapOrElse(f) : (this as None<T>).unwrapOrElse(f);
  }

  // unzip: Added as extension

  /// Returns Some if exactly one of self, [other] is Some, otherwise returns None.
  Option<T> xor(Option<T> other) {
    return this is Some<T> ? (this as Some<T>).xor(other) : (this as None<T>).xor(other);
  }

  /// Zips self with another Option.
  Option<(T, U)> zip<U extends Object>(Option<U> other) {
    return this is Some<T> ? (this as Some<T>).zip(other) : (this as None<T>).zip(other);
  }

  /// Zips self and another Option with function f
  Option<R> zipWith<U extends Object, R extends Object>(Option<U> other, R Function(T, U) f) {
    return this is Some<T> ? (this as Some<T>).zipWith(other, f) : (this as None<T>).zipWith(other, f);
  }

  //************************************************************************//

  /// Returns the inner type as the nullable version of [T]
  T? toNullable() {
    return v;
  }

  //************************************************************************//

  /// Functions an "Early Return Operator" when given an "Early Return key" "$". See [Option.$] for more information.
  T operator [](_OptionEarlyReturnKey op) // ignore: library_private_types_in_public_api
  {
    return this is Some<T> ? (this as Some<T>)[op] : (this as None<T>)[op];
  }
}

extension type const Some<T extends Object>._(T v) implements Option<T>, Object {
  const Some(T v) : this._(v);

  
  Option<U> and<U extends Object>(Option<U> other) {
    return other;
  }

  
  Option<U> andThen<U extends Object>(Option<U> Function(T self) f) {
    return f(v);
  }

  
  Option<T> copy() {
    return Some(v);
  }

  
  T expect(String msg) {
    return v;
  }

  
  Option<T> filter(bool Function(T self) predicate) {
    if (predicate(v)) {
      return Some(v);
    }
    return const None();
  }

  
  Option<T> inspect(Function(T self) f) {
    f(v);
    return this;
  }

  
  bool isNone() {
    return false;
  }

  
  bool isSome() {
    return true;
  }

  
  bool isSomeAnd(bool Function(T self) f) {
    return f(v);
  }

  
  Iterable<T> iter() sync* {
    yield v;
  }

  
  Option<U> map<U extends Object>(U Function(T self) f) {
    return Some(f(v));
  }

  
  U mapOr<U extends Object>(U defaultValue, U Function(T) f) {
    return f(v);
  }

  
  U mapOrElse<U extends Object>(U Function() defaultFn, U Function(T) f) {
    return f(v);
  }

  
  Result<T, E> okOr<E extends Object>(E err) {
    return Ok(v);
  }

  
  Result<T, E> okOrElse<E extends Object>(E Function() errFn) {
    return Ok(v);
  }

  
  Option<T> or(Option<T> other) {
    return Some(v);
  }

  
  Option<T> orElse(Option<T> Function() f) {
    return Some(v);
  }

  
  T? toNullable() {
    return v;
  }

  
  T unwrap() {
    return v;
  }

  
  T unwrapOr(T defaultValue) {
    return v;
  }

  
  T unwrapOrElse(T Function() f) {
    return v;
  }

  
  Option<T> xor(Option<T> other) {
    if (other.isSome()) {
      return const None();
    }
    return Some(v);
  }

  
  Option<(T, U)> zip<U extends Object>(Option<U> other) {
    if (other.isSome()) {
      return Some((v, other.unwrap()));
    }
    return const None();
  }

  
  Option<R> zipWith<U extends Object, R extends Object>(Option<U> other, R Function(T p1, U p2) f) {
    if (other.isSome()) {
      return Some(f(v, other.unwrap()));
    }
    return const None();
  }

  //************************************************************************//

  
  // ignore: library_private_types_in_public_api
  T operator [](_OptionEarlyReturnKey op) {
    return v;
  }
}

extension type const None<T extends Object>._(Null _) implements Option<Never> {
  
  const None() : this._(null);

  
  Option<U> and<U extends Object>(Option<U> other) {
    return const None();
  }

  
  Option<U> andThen<U extends Object>(Option<U> Function(T self) f) {
    return const None();
  }

  
  Option<T> copy() {
    return const None();
  }

  
  T expect(String msg) {
    throw Panic(onValue: this, reason: msg);
  }

  
  Option<T> filter(bool Function(T self) predicate) {
    return const None();
  }

  
  Option<T> inspect(Function(T self) f) {
    return this;
  }

  
  bool isNone() {
    return true;
  }

  
  bool isSome() {
    return false;
  }

  
  bool isSomeAnd(bool Function(T self) f) {
    return false;
  }

  
  Iterable<T> iter() sync* {}

  
  Option<U> map<U extends Object>(U Function(T self) f) {
    return const None();
  }

  
  U mapOr<U extends Object>(U defaultValue, U Function(T) f) {
    return defaultValue;
  }

  
  U mapOrElse<U extends Object>(U Function() defaultFn, U Function(T) f) {
    return defaultFn();
  }

  
  Result<T, E> okOr<E extends Object>(E err) {
    return Err(err);
  }

  
  Result<T, E> okOrElse<E extends Object>(E Function() errFn) {
    return Err(errFn());
  }

  
  Option<T> or(Option<T> other) {
    return other;
  }

  
  Option<T> orElse(Option<T> Function() f) {
    return f();
  }

  
  T unwrap() {
    throw Panic(reason: "called `unwrap` a None type");
  }

  
  T unwrapOr(T defaultValue) {
    return defaultValue;
  }

  
  T unwrapOrElse(T Function() f) {
    return f();
  }

  
  Option<T> xor(Option<T> other) {
    if (other.isSome()) {
      return other;
    }
    return const None();
  }

  
  Option<(T, U)> zip<U extends Object>(Option<U> other) {
    return const None();
  }

  
  Option<R> zipWith<U extends Object, R extends Object>(Option<U> other, R Function(T p1, U p2) f) {
    return const None();
  }

  //************************************************************************//

  
  T? toNullable() {
    return null;
  }

  //************************************************************************//

  
  // ignore: library_private_types_in_public_api
  T operator [](_OptionEarlyReturnKey op) {
    throw const _OptionEarlyReturnNotification();
  }
}

//************************************************************************//

/// The key that allows early returns for [Option]. The key to the lock.
final class _OptionEarlyReturnKey {
  const _OptionEarlyReturnKey._();
}

/// Thrown from a do notation context
final class _OptionEarlyReturnNotification {
  const _OptionEarlyReturnNotification();
}

typedef _OptionEarlyReturnFunction<T extends Object> = Option<T> Function(_OptionEarlyReturnKey);

typedef _OptionAsyncEarlyReturnFunction<T extends Object> = Future<Option<T>> Function(
    _OptionEarlyReturnKey);

//************************************************************************//

const none = None();
