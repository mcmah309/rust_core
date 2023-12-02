
import 'package:rust_core/option.dart';
import 'package:rust_core/result.dart';

extension OptionOnResultExtension<S extends Object, F extends Object> on Result<S,F> {

  /// Converts a [Result] into an Option, returning [Some] if the [Result] is [Ok], and [None] if the [Result] is [Err].
  Option<S> unwrapOrOption(){
    if(isOk()){
      return Some(unwrap());
    }
    return const None();
  }
}

extension OkOnOptionExtension<S extends Object, F extends Object> on Ok<S,F> {

  /// Converts a [Ok] into an Option, returning [Some].
  Option<S> unwrapOrOption(){
      return Some(unwrap());
  }
}

extension ErrOnOptionExtension<S extends Object, F extends Object> on Err<S,F> {

  /// Converts a [Err] into an Option, returning [None].
  Option<S> unwrapOrOption(){
    return const None();
  }
}

extension ResultOptionExtension<S extends Object, F extends Object> on Result<Option<S>,F> {

  /// Transposes a Result of an Option into an Option of a Result.
  Option<Result<S,F>> transpose(){
      if (isOk()) {
        final val = unwrap();
        if (val.isSome()) {
          return Some(Ok(val.unwrap()));
        }
        return const None();
      }
      else {
        return Some(Err(unwrapErr()));
      }
  }
}

extension OptionResultExtension<S extends Object, F extends Object> on Option<Result<S,F>> {

  /// Transposes an Option of a Result into a Result of an Option.
  Result<Option<S>,F> transpose(){
    if (isSome()) {
      final val = unwrap();
      if (val.isOk()) {
        return Ok(Some(val.unwrap()));
      }
      else {
        return Err(val.unwrapErr());
      }
    }
    return Ok(const None());
  }
}