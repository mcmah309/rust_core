import 'package:meta/meta.dart';

import 'package:rust_core/result.dart';
import 'package:rust_core/panic.dart';

sealed class Option<T extends Object> {

  /// Creates a context for early return, similar to "Do notation". Works like the Rust "?" operator, which is a
  /// "Early Return Operator". Here "$" is used as the "Early Return Key". when "$" is used on a type [None],
  /// immediately the context that "$" belongs to is returned with None(). e.g.
  /// ```
  ///   Option<int> earlyReturn(int val) => Option.$(($){
  ///     int x = intNone()[$];
  ///     return Some(val + 3);
  ///   });
  ///   expect(earlyReturn(2), const None());
  ///```
  /// This should be used at the top level of a function as above. Passing "$" to any other functions, nesting, or
  /// attempting to bring "$" out of the original scope should be avoided.
  factory Option.$(_OptionEarlyReturnFunction<T> fn) {
    try {
      return fn(const _OptionEarlyReturnKey._());
    } on _OptionEarlyReturnNotification catch (e) {
      return const None();
    }
  }

  /// Returns None if the option is None, otherwise returns [other].
  Option<U> and<U extends Object>(Option<U> other);

  ///Returns None if the option is None, otherwise calls f with the wrapped value and returns the result. Some
  ///languages call this operation flatmap.
  Option<U> andThen<U extends Object>(Option<U> Function(T) f);

  /// Shallow copies this Option
  Option<T> copy();

  /// Returns the contained Some value if [Some], otherwise throws a [Panic].
  T expect(String msg);

  /// Returns None if the option is None, otherwise calls predicate with the wrapped value and returns
  /// Some(t) if predicate returns true (where t is the wrapped value), and
  // None if predicate returns false
  Option<T> filter(bool Function(T) predicate);

  // flatten: Added as extension

  // T getOrInsert(T value); // not possible, otherwise would not be const

  // T getOrInsertWith(T Function() f); // not possible, otherwise cannot be const

  // T insert(T value); // not possible, otherwise lose const

  /// Calls the provided closure with a reference to the contained value
  Option<T> inspect(Function(T) f);

  /// Returns true if the option is a None value.
  bool isNone();

  /// Returns true if the option is a Some value.
  bool isSome();

  /// Returns true if the option is a Some and the value inside of it matches a predicate.
  bool isSomeAnd(bool Function(T) f);

  /// Returns an iterable over the possibly contained value.
  Iterable<T> iter();

  /// Maps an this Option<T> to Option<U> by applying a function to a contained value (if Some) or returns None (if
  /// None).
  Option<U> map<U extends Object>(U Function(T) f);

  /// Returns the provided default result (if none), or applies a function to the contained value (if any).
  U mapOr<U extends Object>(U defaultValue, U Function(T) f);

  /// Computes a default function result (if none), or applies a different function to the contained value (if any).
  U mapOrElse<U extends Object>(U Function() defaultFn, U Function(T) f);

  /// Transforms the Option<T> into a Result<T, E>, mapping Some(v) to Ok(v) and None to Err(err).
  Result<T,E> okOr<E extends Object>(E err);

  /// Transforms the Option<T> into a Result<T, E>, mapping Some(v) to Ok(v) and None to Err(err()).
  Result<T,E> okOrElse<E extends Object>(E Function() errFn);

  /// Returns the option if it contains a value, otherwise returns other.
  Option<T> or(Option<T> other);

  /// Returns the option if it contains a value, otherwise calls f and returns the result.
  Option<T> orElse(Option<T> Function() f);

  // Option<T> replace(value); // not possible, otherwise not const

  // Option<T> take(); // not possible, can't transmute into None

  // Option<T> takeIf(bool Function(T) predicate); // not possible, can't transmute into None

  // transpose: Added as extension

  /// Returns the contained Some value, consuming the self value.
  T unwrap();

  /// Returns the contained Some value or a provided default.
  T unwrapOr(T defaultValue);

  /// Returns the contained Some value or computes it from a closure.
  T unwrapOrElse(T Function() f);

  // unzip: Added as extension

  /// Returns Some if exactly one of self, [other] is Some, otherwise returns None.
  Option<T> xor(Option<T> other);

  /// Zips self with another Option.
  Option<(T,U)> zip<U extends Object>(Option<U> other);

  /// Zips self and another Option with function f
  Option<R> zipWith<U extends Object, R extends Object>(Option<U> other, R Function(T,U) f);

  //************************************************************************//

  /// Returns the inner type as the nullable version of [T]
  T? toNullable();

  //************************************************************************//

  /// Functions an "Early Return Operator" when given an "Early Return key" "$". See [Option.$] for more information.
  T operator[](_OptionEarlyReturnKey op); // ignore: library_private_types_in_public_api
}


final class Some<T extends Object> implements Option<T> {
  final T v;

  const Some(this.v);

  @override
  Option<U> and<U extends Object>(Option<U> other) {
    return other;
  }

  @override
  Option<U> andThen<U extends Object>(Option<U> Function(T self) f) {
    return f(v);
  }

  @override
  Option<T> copy() {
    return Some(v);
  }

  @override
  T expect(String msg) {
    return v;
  }

  @override
  Option<T> filter(bool Function(T self) predicate) {
    if(predicate(v)){
      return Some(v);
    }
    return const None();
  }

  @override
  Option<T> inspect(Function(T self) f) {
    f(v);
    return this;
  }

  @override
  bool isNone() {
    return false;
  }

  @override
  bool isSome() {
    return true;
  }

  @override
  bool isSomeAnd(bool Function(T self) f) {
    return f(v);
  }

  @override
  Iterable<T> iter() sync* {
    yield v;
  }

  @override
  Option<U> map<U extends Object>(U Function(T self) f) {
    return Some(f(v));
  }

  @override
  U mapOr<U extends Object>(U defaultValue, U Function(T) f) {
    return f(v);
  }

  @override
  U mapOrElse<U extends Object>(U Function() defaultFn, U Function(T) f) {
    return f(v);
  }

  @override
  Result<T, E> okOr<E extends Object>(E err) {
    return Ok(v);
  }

  @override
  Result<T, E> okOrElse<E extends Object>(E Function() errFn) {
    return Ok(v);
  }

  @override
  Option<T> or(Option<T> other) {
    return Some(v);
  }

  @override
  Option<T> orElse(Option<T> Function() f) {
    return Some(v);
  }

  @override
  T? toNullable() {
    return v;
  }

  @override
  T unwrap() {
    return v;
  }

  @override
  T unwrapOr(T defaultValue) {
    return v;
  }

  @override
  T unwrapOrElse(T Function() f) {
    return v;
  }

  @override
  Option<T> xor(Option<T> other) {
    if(other.isSome()){
      return const None();
    }
    return Some(v);
  }

  @override
  Option<(T, U)> zip<U extends Object>(Option<U> other) {
    if(other.isSome()){
      return Some((v,other.unwrap()));
    }
    return const None();
  }

  @override
  Option<R> zipWith<U extends Object, R extends Object>(Option<U> other, R Function(T p1, U p2) f) {
    if(other.isSome()){
      return Some(f(v,other.unwrap()));
    }
    return const None();
  }

  //************************************************************************//

  @override
  T operator[](_OptionEarlyReturnKey op) { // ignore: library_private_types_in_public_api
    return v;
  }

  //************************************************************************//

  @override
  int get hashCode => v.hashCode;

  @override
  bool operator ==(Object other) {
    return other is Some && other.v == v;
  }

  @override
  String toString() => 'Some($v)';
}


final class None<T extends Object> implements Option<T> {

  @literal
  const None();

  @override
  Option<U> and<U extends Object>(Option<U> other) {
    return const None();
  }

  @override
  Option<U> andThen<U extends Object>(Option<U> Function(T self) f) {
    return const None();
  }

  @override
  Option<T> copy() {
    return const None();
  }

  @override
  T expect(String msg) {
    throw Panic(onValue: this, reason: msg);
  }

  @override
  Option<T> filter(bool Function(T self) predicate) {
    return const None();
  }

  @override
  Option<T> inspect(Function(T self) f) {
    return this;
  }

  @override
  bool isNone() {
    return true;
  }

  @override
  bool isSome() {
    return false;
  }

  @override
  bool isSomeAnd(bool Function(T self) f) {
    return false;
  }

  @override
  Iterable<T> iter() sync* {}

  @override
  Option<U> map<U extends Object>(U Function(T self) f) {
    return const None();
  }

  @override
  U mapOr<U extends Object>(U defaultValue, U Function(T) f) {
    return defaultValue;
  }

  @override
  U mapOrElse<U extends Object>(U Function() defaultFn, U Function(T) f) {
    return defaultFn();
  }

  @override
  Result<T, E> okOr<E extends Object>(E err) {
    return Err(err);
  }

  @override
  Result<T, E> okOrElse<E extends Object>(E Function() errFn) {
    return Err(errFn());
  }

  @override
  Option<T> or(Option<T> other) {
    return other;
  }

  @override
  Option<T> orElse(Option<T> Function() f) {
    return f();
  }

  @override
  T unwrap() {
    throw Panic(reason: "called `unwrap` a None type");
  }

  @override
  T unwrapOr(T defaultValue) {
    return defaultValue;
  }

  @override
  T unwrapOrElse(T Function() f) {
    return f();
  }

  @override
  Option<T> xor(Option<T> other) {
    if(other.isSome()){
      return other;
    }
    return const None();
  }

  @override
  Option<(T, U)> zip<U extends Object>(Option<U> other) {
    return const None();
  }

  @override
  Option<R> zipWith<U extends Object, R extends Object>(Option<U> other, R Function(T p1, U p2) f) {
    return const None();
  }

  //************************************************************************//

  @override
  T? toNullable() {
    return null;
  }

  //************************************************************************//

  @override
  T operator[](_OptionEarlyReturnKey op) { // ignore: library_private_types_in_public_api
    throw const _OptionEarlyReturnNotification();
  }

  //************************************************************************//

  @override
  int get hashCode => 0;

  @override
  bool operator ==(Object other) => other is None;

  @override
  String toString() => "None";
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

//************************************************************************//

const none = None();