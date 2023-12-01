import 'package:meta/meta.dart';

import 'package:rust_core/result.dart';
import 'package:rust_core/panic.dart';

sealed class Option<T extends Object> {

  Option<U> and<U extends Object>(Option<U> other);

  Option<U> andThen<U extends Object>(Option<U> Function(T) f);

  Option<T> copy();

  T expect(String msg);

  Option<T> filter(bool Function(T) predicate);

  // todo flatten

  // T getOrInsert(T value); // not possible, otherwise would not be const

  // T getOrInsertWith(T Function() f); // not possible, otherwise cannot be const

  // T insert(T value); // not possible, otherwise lose const

  Option<T> inspect(Function(T) f);

  bool isNone();

  bool isSome();

  bool isSomeAnd(bool Function(T) f);

  Iterable<T> iter();

  Option<U> map<U extends Object>(U Function(T) f);

  U mapOr<U extends Object>(U defaultValue, U Function(T) f);

  U mapOrElse<U extends Object>(U Function() defaultFn, U Function(T) f);

  Result<T,E> okOr<E extends Object>(E err);

  Result<T,E> okOrElse<E extends Object>(E Function() errFn);

  Option<T> or(Option<T> other);

  Option<T> orElse(Option<T> Function() f);

  // Option<T> replace(value); // not possible, otherwise not const

  // Option<T> take(); // not possible, can't transmute into None

  // Option<T> takeIf(bool Function(T) predicate); // not possible, can't transmute into None

  //todo transpose

  T unwrap();

  T unwrapOr(T defaultValue);

  T unwrapOrElse(T Function() f);

  // todo unzip

  Option<T> xor(Option<T> other);

  Option<(T,U)> zip<U extends Object>(Option<U> other);

  Option<R> zipWith<U extends Object, R extends Object>(Option<U> other, R Function(T,U) f);

  //************************************************************************//

  /// Returns the inner type as the nullable version of [T]
  T? toNullable();
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

  @override
  int get hashCode => v.hashCode;

  @override
  bool operator ==(Object other) {
    return other is Some && other.v == v;
  }
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

  // @override
  // int get hashCode;

  // @override
  // bool operator ==(Object other);
  //todo write tests if override is needed, should all hash and equal eachother
}