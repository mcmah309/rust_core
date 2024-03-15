part of 'option.dart';

extension OptionOptionExtension<T> on Option<Option<T>> {
  /// Converts from Option<Option<T>> to Option<T>.
  Option<T> flatten() {
    return v as Option<T>;
  }
}

extension OptionNullableExtension<T extends Object> on Option<T?> {
  /// Converts from Option<T?> to Option<T>.
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
  Future<Result<Option<S>, F>> transpose() async {
    return then((result) => result.transpose());
  }
}
