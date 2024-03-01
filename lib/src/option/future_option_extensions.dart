import 'package:rust_core/option.dart';

extension FutureToOption1<T extends Object> on Future<T?> {
  /// Converts a Future<T?> to Future<Option<T>>.
  Future<Option<T>> toFutureOption() async {
    var value = await this;
    return value.toOption();
  }
}

extension FutureToOption2<T extends Object> on Future<T> {
  /// Converts a Future<T> to Future<Option<T>>.
  Future<Option<T>> toFutureOption() async {
    return (await this).toOption();
  }
}

extension FutureToOption3<T extends Object> on Option<T> {
  /// Converts a Option<T> to Future<Option<T>>.
  Future<Option<T>> toFutureOption() async {
    return this;
  }
}

// extension FutureOptionOptionExtension<T extends Object>
//     on FutureOption<Option<T>> {
//   /// Converts from FutureOption<Option<T>> to FutureOption<T>.
//   Future<Option<T>> flatten() async {
//     var optionOption = await this;
//     return optionOption.isSome() ? optionOption.unwrap() : const None();
//   }
// }

extension FutureOptionRecord2Extension<T extends Object, U extends Object>
    on FutureOption<(T, U)> {
  /// Unzips a FutureOption containing a tuple into a tuple of FutureOptions.
  Future<(Option<T>, Option<U>)> unzip() async {
    var optionTuple = await this;
    if (optionTuple.isSome()) {
      var (one, two) = optionTuple.unwrap();
      return (Some(one), Some(two));
    }
    return (None(), None());
  }
}
