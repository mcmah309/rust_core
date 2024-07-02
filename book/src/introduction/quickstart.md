# Quickstart

## Setup
### Install

rust_core can be install like any other Dart package.

Dart:
```shell
dart pub add rust_core
```
Flutter:
```shell
flutter pub add rust_core
```

or add directly to your `pubspec.yaml`:
```yaml
dependencies:
  rust_core: <version>
```

### Imports

rust_core follows the same library structure and naming as [Rust's rust_core](https://doc.rust-lang.org/core/).

To that extent, each library can be imported individually
```dart
import 'package:rust_core/result.dart';
```
or in it's entirety
```dart
import 'package:rust_core/rust_core.dart';
```
## General Notes

All of rust_core's classes and methods are well documented in the [docs](https://pub.dev/documentation/rust_core/latest/), but
being an implementation of Rust's core library, you can also refer to [Rust core](https://doc.rust-lang.org/beta/core/index.html) if anything is unclear.
The functionally is the same.

## The Basics

### Result and Option

`Result<T, E>` is the type used for returning and propagating errors.

`Option<T>` represents a value that can be either some value of type `T` (`Some<T>`) or `None`. 
It is used "in place" of `T?` (implemented as a zero cost extension type of `T?`).

These types can be easily chained with other operations.

### The Rust `?` Operator and Early Return Key Notion

`Result<T,E>` and `Option<T>` both support early return key notation, which is a same as the rust `?` operator. 
It returns from the scope if an `Err` or `None` is encountered, otherwise it retrieves the inner value.

Result example:
```dart
Result<double, String> divideBy(int num, int divisor) => divisor == 0 ? Err("Divide by zero error") : Ok(num / divisor); 
Result<double, String> func(int x) => Result(($) { // Early Return Key
   // The function will return here
   int val = divideBy(x, 0)[$] + 10;
   return Ok(val);
 });

 void main(){
    assert(func(5) == Err("Divide by zero error"));
 }
```

### `List` and `Arr`

`Arr` (array) is a compliment to `List`, representing a fixed sized `List`. Having a separate `Arr` type fixes runtime exceptions for trying to grow
a non-growable `List`. It also has zero runtime cost, as it is an extension type of `List` and is more efficient than a growable `List`. With `Arr`, type intent is clear for maintainers and developers are able think about code performance more critically.

#### Iter
rust_core implements the entirety of Rust's stable and unstable [Iterator](https://doc.rust-lang.org/beta/core/iter/trait.Iterator.html) methods.
There are a lot of methods here that many Dart developers may not be familiar with. Definitely worth a look - [docs](https://pub.dev/documentation/rust_core/latest/iter/iter-library.html)

```dart
List<int> list = [1, 2, 3, 4, 5];
RIterator<int> filtered = list.iter().filterMap((e) {
  if (e % 2 == 0) {
    return Some(e * 2);
  }
  return None;
});
expect(filtered, [4, 8]);
```

`RIterator` functions the same as a Rust `Iterator`. For Dart developers, you can think of it as the union of Dart's `Iterator` and `Iterable`. 
check [here](../libs/iter/iter.md) for more info.

#### Slice

A `Slice` is a contiguous sequence of elements in a `List` or `Arr`. Slices are a view into a list without allocating and copying to a new list,
thus slices are more efficient than creating a new `List` with `.sublist()` e.g. `list.sublist(x,y)`.
```dart
var list = [1, 2, 3, 4, 5];
var slice = Slice(list, 1, 4); // or `list.slice(1,4)`
expect(slice, [2, 3, 4]);
var taken = slice.takeLast();
expect(taken, 4);
expect(slice, [2, 3]);
slice[1] = 10;
expect(list, [1, 2, 10, 4, 5]);
```
`Slice` also has <u>a lot</u> of efficient methods for in-place mutation within and between slices - [docs](https://pub.dev/documentation/rust_core/latest/slice/slice-library.html)

## Whats Next?

Checkout any of the other sections in the book for more details and enjoy!