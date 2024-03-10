import 'dart:async';

import 'package:rust_core/result.dart';
import 'package:rust_core/panic.dart';
import 'package:rust_core/typedefs.dart';
import 'package:rust_core/iter.dart';

part 'future_option_extensions.dart';
part 'future_option.dart';
part 'option_extensions.dart';

extension type const Option<T>._(T? v) {
  /// Creates a context for early return, similar to "Do notation". Works like the Rust "?" operator, which is a
  /// "Early Return Operator". Here "$" is used as the "Early Return Key". when "$" is used on a type [_None],
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
  // ignore: library_private_types_in_public_api
  factory Option(_OptionEarlyReturnFunction<T> fn) {
    try {
      return fn(const _OptionEarlyReturnKey._());
    } on _OptionEarlyReturnNotification catch (_) {
      return None;
    }
  }

  /// Creates a context for async early return, similar to "Do notation". Works like the Rust "?" operator, which is a
  /// "Early Return Operator". Here "$" is used as the "Early Return Key". when "$" is used on a type [_None],
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
  static Future<Option<T>> async<T>(
      // ignore: library_private_types_in_public_api
      _OptionAsyncEarlyReturnFunction<T> fn) async {
    try {
      return await fn(const _OptionEarlyReturnKey._());
    } on _OptionEarlyReturnNotification catch (_) {
      return Future.value(None);
    }
  }

  /// Returns None if the option is None, otherwise returns [other].
  Option<U> and<U>(Option<U> other) {
    return v == null ? None : other;
  }

  ///Returns None if the option is None, otherwise calls f with the wrapped value and returns the result. Some
  ///languages call this operation flatmap.
  Option<U> andThen<U>(Option<U> Function(T) f) {
    return v == null ? None : f(v as T);
  }

  // copy: Does not make sense to add here since this is an extension type

  /// Returns the contained Some value if [Some], otherwise throws a [Panic].
  T expect(String msg) {
    return v == null ? throw Panic(onValue: this, reason: msg) : v!;
  }

  /// Returns None if the option is None, otherwise calls predicate with the wrapped value and returns
  /// Some(t) if predicate returns true (where t is the wrapped value), and
  // None if predicate returns false
  Option<T> filter(bool Function(T) predicate) {
    if (v == null) {
      return None;
    } else {
      if (predicate(v as T)) {
        return Some(v as T);
      }
      return None;
    }
  }

  // flatten: Added as extension

  // T getOrInsert(T value); // not possible, otherwise would not be const

  // T getOrInsertWith(T Function() f); // not possible, otherwise cannot be const

  // T insert(T value); // not possible, otherwise lose const

  /// Calls the provided closure with a reference to the contained value
  Option<T> inspect(Function(T) f) {
    if (v == null) {
      return this;
    } else {
      f(v as T);
      return this;
    }
  }

  /// Returns true if the option is a None value.
  bool isNone() {
    return this == null;
  }

  /// Returns true if the option is a Some value.
  bool isSome() {
    return this != null;
  }

  /// Returns true if the option is a Some and the value inside of it matches a predicate.
  bool isSomeAnd(bool Function(T) f) {
    if (v == null) {
      return false;
    } else {
      return f(v as T);
    }
  }

  /// Returns an RIterator over the possibly contained value.
  RIterator<T> iter() {
    if (v == null) {
      return RIterator(<T>[].iterator);
    } else {
      return RIterator([v as T].iterator);
    }
  }

  /// Maps an this Option<T> to Option<U> by applying a function to a contained value (if Some) or returns None (if
  /// None).
  Option<U> map<U>(U Function(T) f) {
    if (v == null) {
      return None;
    } else {
      return Some(f(v as T));
    }
  }

  /// Returns the provided default result (if none), or applies a function to the contained value (if any).
  U mapOr<U>(U defaultValue, U Function(T) f) {
    if (v == null) {
      return defaultValue;
    } else {
      return f(v as T);
    }
  }

  /// Computes a default function result (if none), or applies a different function to the contained value (if any).
  U mapOrElse<U>(U Function() defaultFn, U Function(T) f) {
    if (v == null) {
      return defaultFn();
    } else {
      return f(v as T);
    }
  }

  /// Transforms the Option<T> into a Result<T, E>, mapping Some(v) to Ok(v) and None to Err(err).
  Result<T, E> okOr<E extends Object>(E err) {
    if (v == null) {
      return Err(err);
    } else {
      return Ok(v as T);
    }
  }

  /// Transforms the Option<T> into a Result<T, E>, mapping Some(v) to Ok(v) and None to Err(err()).
  Result<T, E> okOrElse<E extends Object>(E Function() errFn) {
    if (v == null) {
      return Err(errFn());
    } else {
      return Ok(v as T);
    }
  }

  /// Returns the option if it contains a value, otherwise returns other.
  Option<T> or(Option<T> other) {
    if (v == null) {
      return other;
    } else {
      return Some(v as T);
    }
  }

  /// Returns the option if it contains a value, otherwise calls f and returns the result.
  Option<T> orElse(Option<T> Function() f) {
    if (v == null) {
      return f();
    } else {
      return Some(v as T);
    }
  }

  // Option<T> replace(value); // not possible, otherwise not const

  // Option<T> take(); // not possible, can't transmute into None

  // Option<T> takeIf(bool Function(T) predicate); // not possible, can't transmute into None

  // transpose: Added as extension

  /// Returns the contained Some value, consuming the self value.
  T unwrap() {
    if (v == null) {
      throw Panic(reason: "called `unwrap` a None type");
    } else {
      return v!;
    }
  }

  /// Returns the contained Some value or a provided default.
  T unwrapOr(T defaultValue) {
    if (v == null) {
      return defaultValue;
    } else {
      return v!;
    }
  }

  /// Returns the contained Some value or computes it from a closure.
  T unwrapOrElse(T Function() f) {
    if (v == null) {
      return f();
    } else {
      return v!;
    }
  }

  // unzip: Added as extension

  /// Returns Some if exactly one of self, [other] is Some, otherwise returns None.
  Option<T> xor(Option<T> other) {
    if (v == null) {
      if (other.isSome()) {
        return other;
      }
      return None;
    } else {
      if (other.isSome()) {
        return None;
      }
      return Some(v as T);
    }
  }

  /// Zips self with another Option.
  Option<(T, U)> zip<U>(Option<U> other) {
    if (v == null) {
      return None;
    } else {
      if (other.isSome()) {
        return Some((v!, other.unwrap()));
      }
      return None;
    }
  }

  /// Zips self and another Option with function f
  Option<R> zipWith<U, R>(Option<U> other, R Function(T, U) f) {
    if (v == null) {
      return None;
    } else {
      if (other.isSome()) {
        return Some(f(v as T, other.unwrap()));
      }
      return None;
    }
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
    if (v == null) {
      throw const _OptionEarlyReturnNotification();
    } else {
      return v!;
    }
  }
}

extension type const Some<T>._(T v) implements Option<T> {
  const Some(T v) : this._(v);

  Option<U> and<U>(Option<U> other) {
    return other;
  }

  Option<U> andThen<U>(Option<U> Function(T self) f) {
    return f(v);
  }

  Some<T> copy() {
    return Some(v);
  }

  T expect(String msg) {
    return v;
  }

  Option<T> filter(bool Function(T self) predicate) {
    if (predicate(v)) {
      return Some(v);
    }
    return None;
  }

  Some<T> inspect(Function(T self) f) {
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

  RIterator<T> iter() {
    return RIterator([v].iterator);
  }

  Some<U> map<U>(U Function(T self) f) {
    return Some(f(v));
  }

  U mapOr<U>(U defaultValue, U Function(T) f) {
    return f(v);
  }

  U mapOrElse<U>(U Function() defaultFn, U Function(T) f) {
    return f(v);
  }

  Ok<T, Infallible> okOr<E extends Object>(E err) {
    return Ok(v);
  }

  Ok<T, Infallible> okOrElse<E extends Object>(E Function() errFn) {
    return Ok(v);
  }

  Some<T> or(Option<T> other) {
    return Some(v);
  }

  Some<T> orElse(Option<T> Function() f) {
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
      return None;
    }
    return Some(v);
  }

  Option<(T, U)> zip<U>(Option<U> other) {
    if (other.isSome()) {
      return Some((v, other.unwrap()));
    }
    return None;
  }

  Option<R> zipWith<U, R>(Option<U> other, R Function(T p1, U p2) f) {
    if (other.isSome()) {
      return Some(f(v, other.unwrap()));
    }
    return None;
  }

  //************************************************************************//

  // ignore: library_private_types_in_public_api
  T operator [](_OptionEarlyReturnKey op) {
    return v;
  }
}

// ignore: constant_identifier_names
const None = _None();

extension type const _None._(Null _) implements Option<Infallible> {
  const _None() : this._(null);

  _None and<U>(Option<U> other) {
    return None;
  }

  _None andThen<U>(Option<U> Function(void self) f) {
    return None;
  }

  _None copy() {
    return None;
  }

  Infallible expect(String msg) {
    throw Panic(onValue: this, reason: msg);
  }

  _None filter(bool Function(void self) predicate) {
    return None;
  }

  _None inspect(Function(void self) f) {
    return this;
  }

  bool isNone() {
    return true;
  }

  bool isSome() {
    return false;
  }

  bool isSomeAnd(bool Function(void self) f) {
    return false;
  }

  RIterator<_None> iter() {
    return RIterator((const <_None>[]).iterator);
  }

  _None map<U>(U Function(void self) f) {
    return None;
  }

  U mapOr<U>(U defaultValue, U Function(void) f) {
    return defaultValue;
  }

  U mapOrElse<U>(U Function() defaultFn, U Function(void) f) {
    return defaultFn();
  }

  Err<Infallible, E> okOr<E extends Object>(E err) {
    return Err(err);
  }

  Err<Infallible, E> okOrElse<E extends Object>(E Function() errFn) {
    return Err(errFn());
  }

  Option<T> or<T>(Option<T> other) {
    return other;
  }

  Option<T> orElse<T>(Option<T> Function() f) {
    return f();
  }

  Infallible unwrap() {
    throw Panic(reason: "called `unwrap` a None type");
  }

  T unwrapOr<T>(T defaultValue) {
    return defaultValue;
  }

  T unwrapOrElse<T>(T Function() f) {
    return f();
  }

  Option<T> xor<T>(Option<T> other) {
    if (other.isSome()) {
      return other;
    }
    return None;
  }

  _None zip<U>(Option<U> other) {
    return None;
  }

  _None zipWith<U, R>(Option<U> other, R Function(void p1, U p2) f) {
    return None;
  }

  //************************************************************************//

  Null toNullable() {
    return null;
  }

  //************************************************************************//

  // ignore: library_private_types_in_public_api
  Infallible operator [](_OptionEarlyReturnKey op) {
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

typedef _OptionEarlyReturnFunction<T> = Option<T> Function(_OptionEarlyReturnKey);

typedef _OptionAsyncEarlyReturnFunction<T> = Future<Option<T>> Function(_OptionEarlyReturnKey);
