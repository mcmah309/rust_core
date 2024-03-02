# Iter

A Dart `Iterable` is analogous to a Rust `Iterator`. Dart already has an `Iterator` therefore to avoid confusion,
the Dart version of the Rust iterator is `RIterator`. `RIterator` is a zero cost extension type of `Iterable`. `RIterator`
makes working with collections of `rust_core` types and regular Dart types a breeze. e.g.

```dart
    var list = [1, 2, 3, 4, 5];
    var filtered = list.iter().filterMap((e) {
      if (e % 2 == 0) {
        return Some(e * 2);
      }
      return None();
    });
    expect(filtered, [4, 8]);
```