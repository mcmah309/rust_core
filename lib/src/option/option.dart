

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

  T insert(T value);

  T inspect(Function(T) f);

  bool isNone();

  bool isSome();

  bool isSomeAnd(bool Function(T) f);

  Iterable<T> iter();

  Option<U> map<U extends Object>(U Function(T) f);

  U mapOr<U extends Object>(U defaultValue);

  U mapOrElse<U extends Object>(U defaultValue, U Function(T) f);

  Result<T,E> okOr<E extends Object>(E err);

  Result<T,E> okOrElse<E extends Object>(E Function() errFn);

  Option<T> or(Option<T> other);

  Option<T> orElse(Option<T> Function() f);

  Option<T> replace(value);

  Option<T> take(); //todo is this possible? to become none?

  Option<T> takeIf(bool Function(T) predicate); //todo

  //todo transpose

  T unwrap();

  T unwrapOr(T defaultValue);

  T unwrapOrElse(T Function() f);

  // todo unzip

  Option<T> xor(Option<T> other);

  Option<(T,U)> zip<U extends Object>(Option<U> other);

  Option<R> zipWith<U extends Object, R extends Object>(Option<U> other, R Function(T,U) f);

}

final class Some<T extends Object> implements Option<T> {
  final T v;

  Some(this.v);

  //todo hash eq
}

final class None<T extends Object> implements Option<T> {

  None();

  //todo hash eq
}