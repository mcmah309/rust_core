# Iter

A Rust `Iterator` is analogous to the union of a Dart `Iterable` and `Iterator`. Since Dart already has an `Iterator` class, to avoid confusion,
the Dart implementation of the Rust iterator is `RIterator`. `RIterator`
makes working with collections of `rust_core` types and regular Dart types a breeze. e.g.

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

`RIterator` can be iterated like an `Iterable` and is consumed like an `Iterator`.
```dart
    List<int> list = [1, 2, 3, 4, 5, 6, 7, 8, 9];
    RIterator<int> rIterator = list.iter();
    List<int> collect = [];
    for (final e in rIterator.take(5).map((e) => e * e)) {
      if (e.isEven) {
        collect.add(e);
      }
    }
    expect(collect, [4, 16]);
    Option<int> next = rIterator.next();
    expect(next, Some(6));
    collect.add(next.unwrap());
    next = rIterator.next();
    collect.add(next.unwrap());
    expect(next, Some(7));
    while(rIterator.moveNext()){
      collect.add(rIterator.current * rIterator.current);
    }
    expect(collect, [4, 16, 6, 7, 64, 81]);
    expect(rIterator,[]);
```

## Dart vs Rust Example
Goal: Get the index of every "!" in a string not followed by a "?"
```dart
    List<int> answer = [];
    String string = "kl!sd!?!";
    PeekableRIterator<(int, Arr<String>)> iter = string.runes
        .iter()
        .map((e) => String.fromCharCode(e))
        .mapWindows(2, (e) => e)
        .enumerate()
        .peekable();
    out:
    do {
      switch (iter.next()) {
        case Some(v: (int index, var l)):
          switch (l) {
            case ["!", "?"]:
              break;
            case ["!", _]:
              answer.add(index);
            case [_, "!"] when iter.peek().isNone():
              answer.add(index + 1);
          }
        case None:
          break out;
      }
    } while (true);
    expect(answer, [2, 7]);
```
Rust equivlent
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
## Additional Examples
```dart
    /// Extract strings that are 3 long inside brackets '{' '}' and are not apart of other strings
    String string = "jfsdjf{abcdefgh}sda;fj";
    RIterator<String> strings = string.runes
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

Another a big advantage of `RIterator` over `Iterable<T>` and `Iterator<T>` is that `RIterator<T>` is clonable.
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
This for allows for situtations where you want to work ahead and not lose your iterator position, or pass the `RIterator` to another function without needing to call e.g. `collectList()`, `collectArr()`, etc.