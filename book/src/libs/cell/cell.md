# Cell
***
Cell is library of useful wrappers types (cells) - [pub.dev](https://pub.dev/documentation/rust_core/latest/cell/cell-library.html).

[Cell](#cell) - A wrapper with interior mutability.

[OnceCell](#oncecell) - A cell which can be written to only once.

[LazyCell](#lazycell) - A value which is initialized on the first access.

[LazyCellAsync](#lazycellasync) - A value which is asynchronously initialized on the first access.


## Cell
A wrapper with interior mutability. Useful for primitives and an escape hatch for working with immutable data patterns.
`Cell<T>` can be thought of as a `List<T>` with a single object.
```dart
void main() {
  Cell<int> cell = Cell(1);
  mutate(cell);
}

void mutate(Cell<int> cell){
  cell.set(2);
}
```
In a reactive context, such as with flutter, the conceptual equivalent is `ValueNotifier`.

Extensions exist for primitives. e.g. `Cell<int>` can be used similar to a normal `int`.
```dart
Cell<int> cell = Cell(10);
expect(cell.get(), 10);
cell.add(2);
expect(cell.get(), 12);
Cell<int> anotherCell = Cell(10);
Cell<int> newCell = cell + anotherCell;
expect(newCell, 22);
expect(cell, 12);
expect(antherCell, 10);
```
The base type for all `Cell`s is `ConstCell`.

## OnceCell
A cell which can be written to only once. Similar to `late final <variable>`, but will never throw an error.

```dart
OnceCell<int> cell = OnceCell();
var result = cell.set(10);
expect(result, const Ok(()));
result = cell.set(20);
expect(result, const Err(20));
```
The base type for all `OnceCell`s is `NullableOnceCell`.

## LazyCell
A value which is initialized on the first access.

```dart
int callCount = 0;
LazyCell<int> lazyCell = LazyCell(() {
  callCount++;
  return 20;
});
LazyCell<int> firstCall = lazyCell();
expect(callCount, equals(1));
expect(firstCall, equals(20));
LazyCell<int> secondCall = lazyCell();
expect(callCount, equals(1));
expect(secondCall, equals(20));
```
The base type for all `LazyCell`s is `NullableLazyCell`.

## LazyCellAsync
A value which is asynchronously initialized on the first access.

```dart
int callCount = 0;
LazyCellAsync<int> lazyCell = LazyCellAsync(() async {
  callCount++;
  return 20;
});
LazyCellAsync<int> firstCall = await lazyCell.force();
expect(callCount, equals(1));
expect(firstCall, equals(20));
LazyCellAsync<int> secondCall = lazyCell(); // Could also call `await lazyCell.force()` again.
expect(callCount, equals(1));
expect(secondCall, equals(20));
```
The base type for all `LazyCellAsync`s is `NullableLazyCellAsync`.
