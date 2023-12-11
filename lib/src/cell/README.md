# Cell

Cell is library of useful wrappers of values (cells). [pub]

[Cell](#cell) - A wrapper around a mutable value.

[OnceCell](#oncecell) - A cell which can be written to only once.

[LazyCell](#lazycell) - A value which is initialized on the first access.


## Cell
A wrapper around a mutable value. Useful for mimicking references and wrapping primitives. Extensions exist for 
primitives. e.g. `Cell<int>` can be used similar to a normal `int`.
```dart
final cell = Cell<int>(10);
expect(cell.get(), 10);
cell.add(2);
expect(cell.get(), 12);
final anotherCell = Cell<int>(10);
final newCell = cell + anotherCell;
expect(newCell, 22);
expect(cell, 12);
expect(antherCell, 10);
```

## OnceCell
A cell which can be written to only once. Similar to `late final <variable>`, but will never throw an error.

```dart
final cell = OnceCell<int>();
var result = cell.set(10);
expect(result, const Ok(()));
result = cell.set(20);
expect(result, const Err(20));
```

## LazyCell
A value which is initialized on the first access.

```dart
int callCount = 0;
final lazyCell = LazyCell<int>(() {
  callCount++;
  return 20;
});
final firstCall = lazyCell();
expect(callCount, equals(1));
expect(firstCall, equals(20));
final secondCall = lazyCell();
expect(callCount, equals(1));
expect(secondCall, equals(20));
```

## Misc

### Const and Nullability
Most of the time you will not need to know or care about this, and working
with the regular cell types is usually preferred, but
all Cells have `const`, `nullable` and `non-nullable` implementations. These were added for efficiency and to give 
more control to developers. e.g. Non-Nullable `OnceCell` and `LazyCell` (which is the default) don't need an 
additional `bool` to keep track if the value is set.

The base type for all `Cell`s is `ConstCell`.

The base type for all `OnceCell`s is `NullableOnceCell`.

The base type for all `LazyCell`s is `NullableLazyCell`.

`OnceCell` and `LazyCell` have special `constNullable` and `constNonNullable` implementations. These
allow for runtime mutability of the inner value. That opens up a lot of possibilities. e.g. 
You can wrap non-const types. Allowing them to be used for something like `@Default(...)`
with the [freezed] package.

[freezed]:https://pub.dev/packages/freezed
[pub]:https://pub.dev/documentation/rust_core/latest/cell/cell-library.html