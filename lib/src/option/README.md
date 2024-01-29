# Option

Option represents the union of two types `Some` and `None`. An alternative to null. The `Option` type is not meant 
to replace nullable types, but rather complement them. [This](#to-option-or-not-to-option) section discusses more. But all 
types in rust_core support nullable and `Option` implementations of classes and methods, to allow full usability of 
rust_core with or without the `Option` type. Giving you greater control.

### Usage
The `Option` Type and features work very similar to [Result]. We are able to chain operations in a safe way without
needing a bunch of `if` statements to check if a value is null.

```dart
Option<int> intOptionFunc() => const None();
double halfVal(int val) => val/2;
Option<double> val = intOptionFunc()
    .map(halfVal);
expect(val.unwrapOr(2), 2);
```
See the [docs] for all methods and extensions.

You can also use Option in pattern matching
```dart
switch(Some(2)){
  case Some(:final v):
    // do somthing
  case None():
    // do something
}
```

### Early Return Key Notation
Option also supports "Early Return Key Notation" (ERKN), which is a derivative of "Do Notation". It allows a 
function to return early if the value 
is `None`, otherwise the `Some` value of the option can be used without needing to unwrap or typecheck.
```dart
Option<int> intNone() => const None();
Option<double> earlyReturn(int val) => Option(($) { // Early Return Key
  // Returns here
  double x = intNone()[$].toDouble();
  return Some(val + x);
});
expect(earlyReturn(2), const None());
```
This is a powerful concept and make you code much more concise without losing any safety.

For async, use `Option.async` e.g.
```dart
FutureOption<double> earlyReturn() => Option.async(($) async {
  ...
});
```

### To Option or Not To Option
If Dart already supports nullable types, why use an
option type? This [article] by one of the [fpdart] authors explains it nicely. But to concentrate on a single point,
chaining null specific operations is not possible and the only alternate solution is a bunch of if statements and
implicit and explicit type promotion. The `Option` type solves these issues.

That said, it may be best to standardize around a single approach, either `Option` or nullable types. But it is
perfectly acceptable to use both.

If mixing nullable types and `Option`, the recommended approach is to use the `Option` type as the return type.
Using return type `Option` allows for chaining operations.
But the choice is up to the developer. Either way extension methods
`toOption` and `toNullable` exist to easily convert back and forth.

[article]: https://www.sandromaglione.com/articles/option_type_and_null_safety_dart
[fpdart]: https://pub.dev/packages/fpdart
[Result]: https://github.com/mcmah309/rust_core/tree/master/lib/src/result
[docs]: https://pub.dev/documentation/rust_core/latest/option/option-library.html