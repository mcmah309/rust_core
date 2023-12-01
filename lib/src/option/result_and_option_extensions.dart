
import '../../rust_core.dart';

extension OptionOnResultExtension<S extends Object, F extends Object> on Result<S,F> {
  Option<S> unwrapOrOption(){
    if(isOk()){
      return Some(unwrap());
    }
    return const None();
  }
}

extension OkOnOptionExtension<S extends Object, F extends Object> on Ok<S,F> {
  Option<S> unwrapOrOption(){
      return Some(unwrap());
  }
}

extension ErrOnOptionExtension<S extends Object, F extends Object> on Err<S,F> {
  Option<S> unwrapOrOption(){
    return const None();
  }
}

extension ResultOptionExtension<S extends Object, F extends Object> on Result<Option<S>,F> {
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