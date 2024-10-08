part of 'option.dart';

extension OptionOptionExtension<T> on Option<Option<T>> {
  /// Converts from Option<Option<T>> to Option<T>.
  @pragma("vm:prefer-inline")
  Option<T> flatten() {
    return v as Option<T>;
  }
}

extension OptionNullableExtension<T extends Object> on Option<T?> {
  /// Converts from Option<T?> to Option<T>.
  @pragma("vm:prefer-inline")
  Option<T> flatten() {
    return Option._(v);
  }
}

extension OptionRecord2Extension<T, U> on Option<(T, U)> {
  /// Unzips an option containing a tuple of two options.
  /// If self is Some((a, b)) this method returns (Some(a), Some(b)). Otherwise, (None, None) is returned.
  (Option<T>, Option<U>) unzip() {
    if (isSome()) {
      final (one, two) = unwrap();
      return (Some(one), Some(two));
    }
    return (None, None);
  }
}

extension OptionResultExtension<S extends Object, F extends Object>
    on Option<Result<S?, F>> {
  /// Transposes an Option of a Result into a Result of an Option.
  Result<Option<S>, F> transpose() {
    if (isSome()) {
      final val = unwrap();
      if (val.isOk()) {
        return Ok(Option._(val.unwrap()));
      } else {
        return Err(val.unwrapErr());
      }
    }
    return Ok(None);
  }
}

extension FutureOptionResultExtension<S extends Object, F extends Object>
    on FutureOption<Result<S?, F>> {
  /// Transposes an FutureOption of a Result into a Result of an Option.
  @pragma("vm:prefer-inline")
  Future<Result<Option<S>, F>> transpose() async {
    return then((result) => result.transpose());
  }
}

extension OptionNestedRecord3Extension<A, B, C> on Option<((A, B), C)> {
  /// Flattens an option into a single tuple.
  Option<(A, B, C)> flatten() {
    return map((e) => (e.$1.$1, e.$1.$2, e.$2));
  }
}

extension OptionNestedRecord4Extension<A, B, C, D> on Option<(((A, B), C), D)> {
  /// Flattens an option into a single tuple.
  Option<(A, B, C, D)> flatten() {
    return map((e) => (e.$1.$1.$1, e.$1.$1.$2, e.$1.$2, e.$2));
  }
}

extension OptionNestedRecord5Extension<A, B, C, D, E>
    on Option<((((A, B), C), D), E)> {
  /// Flattens an option into a single tuple.
  Option<(A, B, C, D, E)> flatten() {
    return map(
        (e) => (e.$1.$1.$1.$1, e.$1.$1.$1.$2, e.$1.$1.$2, e.$1.$2, e.$2));
  }
}
