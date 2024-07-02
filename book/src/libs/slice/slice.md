# Slice
***
A `Slice` is a contiguous sequence of elements in a [List]. Slices are a view into a list without allocating and copying to a new list,
thus slices are more efficient than creating a sub-list, but they do not own their own data. That means shrinking the original list can cause the slices range to become invalid, which may cause an exception.

`Slice` also has a lot of efficient methods for in-place mutation within and between slices. e.g.

```dart
    var list = [1, 2, 3, 4, 5];
    var slice = Slice(list, 1, 4);
    slice = list.slice(1,4); // alternative
    expect(slice, [2, 3, 4]);
    var taken = slice.takeLast();
    expect(taken, 4);
    expect(slice, [2, 3]);
    slice[1] = 10;
    expect(list, [1, 2, 10, 4, 5]);
```