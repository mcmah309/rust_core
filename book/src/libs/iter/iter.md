# Iter
***
A Rust `Iterator` is analogous to the union of a Dart `Iterable` and `Iterator`. Since Dart already has an `Iterator` class, to avoid confusion,
the Dart implementation of the Rust iterator is `Iter`. `Iter`
makes working with collections of `rust_core` types and regular Dart types a breeze. e.g.

```dart
List<int> list = [1, 2, 3, 4, 5];
Iter<int> filtered = list.iter().filterMap((e) {
  if (e % 2 == 0) {
    return Some(e * 2);
  }
  return None;
});
expect(filtered, [4, 8]);
```

`Iter` can be retrieved by calling `iter()` on an `Iterable` or an `Iterator`. `Iter` can be iterated
 like an `Iterable` or `Iterator`, and is consumed like an `Iterator`.
```dart
List<int> list = [1, 2, 3, 4, 5, 6, 7, 8, 9];
Iter<int> iter = list.iter();
List<int> collect = [];
for (final e in iter.take(5).map((e) => e * e)) {
  if (e.isEven) {
    collect.add(e);
  }
}
expect(collect, [4, 16]);
Option<int> next = iter.next();
expect(next, Some(6));
collect.add(next.unwrap());
next = iter.next();
collect.add(next.unwrap());
expect(next, Some(7));
while(iter.moveNext()){
  collect.add(iter.current * iter.current);
}
expect(collect, [4, 16, 6, 7, 64, 81]);
expect(iter,[]);
```

`Iter` contains many more useful methods than the base Dart `Iterable` class and works in all places you
would reach for an `Iterator` - [pub.dev](https://pub.dev/documentation/rust_core/latest/iter/iter-library.html)

## Dart vs Rust Example
Goal: Get the index of every "!" in a string not followed by a "?"
```dart
import 'package:rust_core/rust_core.dart';

void main() {
  List<int> answer = [];
  String string = "kl!sd!?!";
  Peekable<(int index, Arr<String> window)> iter = string
      .chars()
      .mapWindows(2, identity)
      .enumerate()
      .peekable();
  while (iter.moveNext()) {
    final (int index, Arr<String> window) = iter.current;
    switch (window) {
      case ["!", "?"]:
        break;
      case ["!", _]:
        answer.add(iter.current.$1);
      case [_, "!"] when iter.peek().isNone():
        answer.add(index + 1);
    }
  }
  expect(answer, [2, 7]);
}
```
Rust equivalent
```rust
use std::iter::Peekable;

fn main() {
  let mut answer: Vec<usize> = Vec::new();
  let string = "kl!sd!?!";
  let mut iter: Peekable<_> = string
      .chars()
      .map_windows(|w: &[char; 2]| *w)
      .enumerate()
      .peekable();

  while let Some((index, window)) = iter.next() {
      match window {
          ['!', '?'] => continue,
          ['!', _] => answer.push(index),
          [_, '!'] if iter.peek().is_none() => answer.push(index + 1),
          _ => continue,
      }
  }
  assert_eq!(answer, [2, 7]);
}
```
## Additional Examples
```dart
    /// Extract strings that are 3 long inside brackets '{' '}' and are not apart of other strings
    String string = "jfsdjf{abcdefgh}sda;fj";
    Iter<String> strings = string.runes
        .iter()
        .skipWhile((e) => e != "{".codeUnitAt(0))
        .skip(1)
        .arrayChunks(3)
        .takeWhile((e) => e[2] != "}".codeUnitAt(0))
        .map((e) => String.fromCharCodes(e));
    expect(strings, ["abc", "def"]);
```

## Misc
### Clone

Another a big advantage of `Iter` over `Iterable<T>` and `Iterator<T>` is that `Iter<T>` is clonable.
This means the iterator can be cloned without cloning the underlying data.
```dart
    var list = [1, 2, 3, 4, 5];
    var iter1 = list.iter();
    iter1.moveNext();
    var iter2 = iter1.clone();
    iter2.moveNext();
    var iter3 = iter2.clone();
    iter3.moveNext();
    var iter4 = iter1.clone();
    expect(iter1.collectList(), [2, 3, 4, 5]);
    expect(iter2.collectList(), [3, 4, 5]);
    expect(iter3.collectList(), [4, 5]);
    expect(iter4.collectList(), [2, 3, 4, 5]);
```
This allows for situations where you want to work ahead and not lose your iterator position, or pass the `Iter` to another function without needing to call e.g. `collectList()`, `collectArr()`, etc.