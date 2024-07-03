# FAQ

## Why Use Rust Core If I Don't Know Rust?
***
From a language perspective we believe Dart is sadly lacking in a few areas, of which this package solves:

* Dart utilizes unchecked try/catch exceptions. Handling errors as values is preferred for maintainability, thus the `Result` type.
* Dart has nullable types but you cannot do null or non-null specific operations without a bunch of `if` statements. `Option<T>` fixes this with no runtime cost and you can easily switch back and forth to nullable types since it is just a zero cost extension type of `T?`.
* Dart is missing the functionality of Rust's `?` operator, so we implemented it in Dart.
* Dart is missing a built in `Cell` type or equivalent (and `OnceCell`/`LazyCell`).
* Dart's `List` type is an array/vector union (it's growable or non-growable). This is not viewable at the type layer, which may lead to runtime exceptions and encourages using growable `List`s everywhere even when you do not need to, which is less performant. So we added `Arr` (array).
* Dart has no concept of a slice type, so allocating sub-lists is the only method, which is not that efficient. So we added `Slice<T>`.
* Dart's between isolate communication is by ports (`ReceivePort`/`SendPort`), which is untyped and horrible, we standardized this with introducing `channel` for typed bi-directional isolate communication.
* Dart's iteration methods are lacking for `Iterable` and `Iterator` (there are none! just `moveNext()` and `current`), while Rust has an abundance of useful methods. So we introduced Rust's `Iterator`.

## I Know Rust, Can This Package Benefit My Team and I?
***
Absolutely! In fact, our team both programs in and love Dart and Rust. From a team and user perspective, having one common api across two different languages greatly increases our development velocity in a few ways:

* Context switching is minimized, the api's across the two languages are the same.
* Shrinking the knowledge gap between Rust and Dart developers.