# Option

Option represents the union of two types `Some` and `None`. An alternative to null. The `Option` type is not meant 
to replace nullable types, but rather complement them. The [Motivation](#motivation) section discusses more. But all 
types in rust_core support nullable and `Option` implementations of classes and methods, to allow full usability of 
rust_core with or without the `Option` type. Giving programmers greater control.

### Motivation
If Dart already supports nullable types, why use an 
option type? This [article] by one of the [fpdart] authors explains it nicely. But to concentrate on a single point,
chaining null specific operations is not possible and the only alternate solution is a bunch of if statements and 
implicit and explicit type promotion. The `Option` type solves these issues.

When deciding between the two, the recommended approach is to use the `Option` type as the return type and nullable 
types as parameter types.

### Usage
The `Option` Type and features work very similar to `Result` see the [Result] page for more info. Or the pub [docs]

🚧 **Documentation is Under Construction** 🚧

[article]: https://www.sandromaglione.com/articles/option_type_and_null_safety_dart
[fpdart]: https://pub.dev/packages/fpdart
[Result]: https://github.com/mcmah309/rust_core/tree/master/lib/src/result
[docs]: https://pub.dev/documentation/rust_core/latest/option/option-library.html