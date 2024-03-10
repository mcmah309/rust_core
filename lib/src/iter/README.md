# Iter

A Rust `Iterator` is analogous to the union of a Dart `Iterable` and `Iterator`. Since Dart already has an `Iterator` class, to avoid confusion,
the Dart implementation of the Rust iterator is `RIterator`. `RIterator`
makes working with collections of `rust_core` types and regular Dart types a breeze. e.g.

```dart
    var list = [1, 2, 3, 4, 5];
    var filtered = list.iter().filterMap((e) {
      if (e % 2 == 0) {
        return Some(e * 2);
      }
      return None;
    });
    expect(filtered, [4, 8]);
```

`RIterator` can be iterated like an `Iterable` and is consumed like an `Iterator`.
```dart
    final list = [1, 2, 3, 4, 5, 6, 7, 8, 9];
    final rIterator = list.iter();
    final collect = [];
    for (final e in rIterator.take(5).map((e) => e * e)) {
      if (e.isEven) {
        collect.add(e);
      }
    }
    expect(collect, [4, 16]);
    Option<int> next = rIterator.next();
    expect(next, Some(6));
    collect.add(next);
    next = rIterator.next();
    collect.add(next);
    expect(next, Some(7));
    while(rIterator.moveNext()){
      collect.add(rIterator.current * rIterator.current);
    }
    expect(collect, [4, 16, 6, 7, 64, 81]);
    expect(rIterator,[]);
```