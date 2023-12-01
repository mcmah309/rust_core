import 'package:meta/meta.dart';

import '../../rust_core.dart';

sealed class Option<T extends Object> {

  Option<U> and<U extends Object>(Option<U> other);

  Option<U> andThen<U extends Object>(Option<U> Function(T) f);

  Option<T> copy();

  T expect(String msg);

  Option<T> filter(bool Function(T) predicate);

  // todo flatten

  T getOrInsert(T value);

  T getOrInsertWith(T Function() f);

  // insert is not possible, otherwise lose const

  T inspect(Function(T) f);

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

  // replace is not possible, otherwise not const

  // take is not possible, can't transmute into None

  // takeIf is not possible, can't transmute into None

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
  T getOrInsert(T value) {
    return v;
  }

  @override
  T getOrInsertWith(T Function() f) {
    return v;
  }

  @override
  T inspect(Function(T self) f) {
    f(v);
    return v;
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
    // TODO: implement and
    throw UnimplementedError();
  }

  @override
  Option<U> andThen<U extends Object>(Option<U> Function(T self) f) {
    // TODO: implement andThen
    throw UnimplementedError();
  }

  @override
  Option<T> copy() {
    // TODO: implement copy
    throw UnimplementedError();
  }

  @override
  T expect(String msg) {
    // TODO: implement expect
    throw UnimplementedError();
  }

  @override
  Option<T> filter(bool Function(T self) predicate) {
    // TODO: implement filter
    throw UnimplementedError();
  }

  @override
  T getOrInsert(T value) {
    // TODO: implement getOrInsert
    throw UnimplementedError();
  }

  @override
  T getOrInsertWith(T Function() f) {
    // TODO: implement getOrInsertWith
    throw UnimplementedError();
  }

  @override
  T inspect(Function(T self) f) {
    // TODO: implement inspect
    throw UnimplementedError();
  }

  @override
  bool isNone() {
    // TODO: implement isNone
    throw UnimplementedError();
  }

  @override
  bool isSome() {
    // TODO: implement isSome
    throw UnimplementedError();
  }

  @override
  bool isSomeAnd(bool Function(T self) f) {
    // TODO: implement isSomeAnd
    throw UnimplementedError();
  }

  @override
  Iterable<T> iter() {
    // TODO: implement iter
    throw UnimplementedError();
  }

  @override
  Option<U> map<U extends Object>(U Function(T self) f) {
    // TODO: implement map
    throw UnimplementedError();
  }

  @override
  U mapOr<U extends Object>(U defaultValue, U Function(T) f) {
    // TODO: implement mapOr
    throw UnimplementedError();
  }

  @override
  U mapOrElse<U extends Object>(U Function() defaultFn, U Function(T) f) {
    // TODO: implement mapOrElse
    throw UnimplementedError();
  }

  @override
  Result<T, E> okOr<E extends Object>(E err) {
    // TODO: implement okOr
    throw UnimplementedError();
  }

  @override
  Result<T, E> okOrElse<E extends Object>(E Function() errFn) {
    // TODO: implement okOrElse
    throw UnimplementedError();
  }

  @override
  Option<T> or(Option<T> other) {
    // TODO: implement or
    throw UnimplementedError();
  }

  @override
  Option<T> orElse(Option<T> Function() f) {
    // TODO: implement orElse
    throw UnimplementedError();
  }

  @override
  T? toNullable() {
    // TODO: implement toNullable
    throw UnimplementedError();
  }

  @override
  T unwrap() {
    // TODO: implement unwrap
    throw UnimplementedError();
  }

  @override
  T unwrapOr(T defaultValue) {
    // TODO: implement unwrapOr
    throw UnimplementedError();
  }

  @override
  T unwrapOrElse(T Function() f) {
    // TODO: implement unwrapOrElse
    throw UnimplementedError();
  }

  @override
  Option<T> xor(Option<T> other) {
    // TODO: implement xor
    throw UnimplementedError();
  }

  @override
  Option<(T, U)> zip<U extends Object>(Option<U> other) {
    // TODO: implement zip
    throw UnimplementedError();
  }

  @override
  Option<R> zipWith<U extends Object, R extends Object>(Option<U> other, R Function(T p1, U p2) f) {
    // TODO: implement zipWith
    throw UnimplementedError();
  }

  //************************************************************************//

  // @override
  // int get hashCode;

  // @override
  // bool operator ==(Object other);
  //todo write tests if override is needed
}