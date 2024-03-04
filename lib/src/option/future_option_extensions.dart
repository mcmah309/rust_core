part of 'option.dart';

extension FutureToOption<T extends Object> on Future<T?> {
  /// Converts a Future<T?> to Future<Option<T>>.
  Future<Option<T>> toFutureOption() async {
    return then((value) => Option._(value));
  }
}

extension OptionToFutureOption<T> on Option<T> {
  /// Converts a Option<T> to Future<Option<T>>.
  Future<Option<T>> toFutureOption() async {
    return this;
  }
}

extension FutureOptionOptionExtension<T> on FutureOption<Option<T>> {
  /// Converts from FutureOption<Option<T>> to FutureOption<T>.
  Future<Option<T>> flatten() async {
    var optionOption = await this;
    return optionOption.isSome() ? optionOption.unwrap() : const _None();
  }
}

extension FutureOptionRecord2Extension<T, U> on FutureOption<(T, U)> {
  /// Unzips a FutureOption containing a tuple into a tuple of FutureOptions.
  Future<(Option<T>, Option<U>)> unzip() async {
    var optionTuple = await this;
    if (optionTuple.isSome()) {
      var (one, two) = optionTuple.unwrap();
      return (Some(one), Some(two));
    }
    return (_None(), _None());
  }
}

extension OptionResultExtension<S, F extends Object> on Option<Result<S, F>> {
  /// Transposes an Option of a Result into a Result of an Option.
  Result<Option<S>, F> transpose() {
    if (isSome()) {
      final val = unwrap();
      if (val.isOk()) {
        return Ok(Some(val.unwrap()));
      } else {
        return Err(val.unwrapErr());
      }
    }
    return Ok(const _None());
  }
}

extension FutureOptionResultExtension<S, F extends Object>
    on FutureOption<Result<S, F>> {
  /// Transposes an FutureOption of a Result into a Result of an Option.
  Future<Result<Option<S>, F>> transpose() async {
    return then((result) => result.transpose());
  }
}
