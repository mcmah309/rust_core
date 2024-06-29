# New To Dart

Welcome to Dart!

Dart is a great language choice for fast cross platform development (especially in the ui) and scripting.

rust_core is great start to learn the Dart semantics as you will feel like you are writing native rust. Just look at this Rust code:
> Goal: Get the index of every "!" in a string not followed by a "?"
```rust
use std::iter::Peekable;

fn main() {
    let mut answer: Vec<usize> = Vec::new();
    let string = "kl!sd!?!";
    let chars: Vec<char> = string
      .chars()
      .collect();
    let mut iter: Peekable<_> = chars
      .windows(2)
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
Dart equivalent with rust_core:
```dart
import 'package:rust_core/prelude';

void main() {
    List<int> answer = [];
    String string = "kl!sd!?!";
    Peekable<(int, Arr<String>)> iter = string
        .chars()
        .windows(2)
        .enumerate()
        .peekable();
    while (iter.moveNext()) {
      final (index, window) = iter.current;
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

rust_core will introduce you to a few new types you may find useful as a Dart developer:

| Rust Type         | Dart Equivalent | rust_core | Description                                             |
|-------------------|-----------------|----------------------|---------------------------------------------------------|
| `Vec<T>`          | `List<T>`       | `Vec<T>`*                    | Dynamic array or list.                                  |
| `[T; N]`          | `const [...]`/`List<T>(growable: false)` | `Arr<T>`            | Fixed size array or list                                   |
| `Iterator<T>`     | `Iterable<T>`   |  `RIterator<T>`                  | Composable iteration
| `Option<T>`       | `T?`            | `Option<T>`                    | A type that may hold a value or none.                   |
| `Result<T, E>`    |  - | `Result<T, E>`  | Type used for returning and propagating errors.|                         |
| `Path`            | - | `Path`*  | Type for file system path manipulation.
| `[T]`             | - | `Slice<T>`                    | View into an array or list.                                  |
| `Cell<T>`             | - | `Cell<T>`                    | wrappers of values                                  |

> *: Implemented through additional packages found [here](../misc/packages_built_on_rust_core.md)