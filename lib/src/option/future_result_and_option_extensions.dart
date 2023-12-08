import 'package:rust_core/option.dart';

extension FutureOptionOnResultExtension<S extends Object, F extends Object>
    on FutureResult<S, F> {
  /// Converts a FutureResult<S, F> into FutureOption<S>.
  Future<Option<S>> unwrapOrOption() async {
    return then((result) => result.unwrapOrOption());
  }
}

extension FutureResultOptionExtension<S extends Object, F extends Object>
    on FutureResult<Option<S>, F> {
  /// Transposes a FutureResult of an Option into an Option of a Result.
  Future<Option<Result<S, F>>> transpose() async {
    return then((result) => result.transpose());
  }
}

extension FutureOptionResultExtension<S extends Object, F extends Object>
    on FutureOption<Result<S, F>> {
  /// Transposes an FutureOption of a Result into a Result of an Option.
  Future<Result<Option<S>, F>> transpose() async {
    return then((result) => result.transpose());
  }
}
