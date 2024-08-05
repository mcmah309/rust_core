# Slice
***
A `Slice` is a contiguous sequence of elements in a `List`. Slices are a view into a list without allocating and copying to a new list,
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

## Examples

### Array Windows

Create overlapping windows of a specified size from a list:

```dart
import 'package:rust_core/slice.dart';

void main() {
  var list = [1, 2, 3, 4, 5];
  var slice = Slice(list, 0, 5);
  var windows = slice.arrayWindows(2);
  print(windows); // [[1, 2], [2, 3], [3, 4], [4, 5]]
}
```

### Chunking

Split a list into chunks of a specified size:

```dart
import 'package:rust_core/slice.dart';

void main() {
  var list = [1, 2, 3, 4, 5];
  var slice = list.slice();
  var (chunks, remainder) = slice.asChunks(2);
  print(chunks); // [[1, 2], [3, 4]]
  print(remainder); // [5]
}
```

### Binary Search

Perform binary search on a sorted list:

```dart
import 'package:rust_core/slice.dart';

void main() {
  Slice<num> s = [0, 1, 1, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55].slice();
  var result = s.binarySearch(13);
  print(result); // Ok(9)
}
```

### Rotations

Rotate elements to the left or right:

```dart
import 'package:rust_core/slice.dart';

void main() {
  var list = ['a', 'b', 'c', 'd', 'e', 'f'];
  var slice = list.asSlice();
  slice.rotateLeft(2);
  print(slice); // ['c', 'd', 'e', 'f', 'a', 'b']

  slice.rotateRight(2);
  print(slice); // ['e', 'f', 'a', 'b', 'c', 'd']
}
```

### Deduplication

Remove duplicate elements based on a custom equality function:

```dart
import 'package:rust_core/slice.dart';

void main() {
  var list = ["foo", "Foo", "BAZ", "Bar", "bar", "baz", "BAZ"];
  var slice = list.asSlice();
  var (dedup, duplicates) = slice.partitionDedupBy((a, b) => a.toLowerCase() == b.toLowerCase());
  print(dedup); // ["foo", "BAZ", "Bar"]
  print(duplicates); // ["Foo", "bar", "baz"]
}
```

### Sorting

Sort elements in-place:

```dart
import 'package:rust_core/slice.dart';

void main() {
  var list = [5, 4, 3, 2, 1];
  var slice = list.asSlice();
  slice.sortUnstable();
  print(slice); // [1, 2, 3, 4, 5]
}
```

### Reversing

Reverse the elements in a list:

```dart
import 'package:rust_core/slice.dart';

void main() {
  var list = [1, 2, 3, 4, 5];
  var slice = list.asSlice();
  slice.reverse();
  print(slice); // [5, 4, 3, 2, 1]
}
```

### Partitioning

Partition elements into those that satisfy a predicate and those that don't:

```dart
import 'package:rust_core/slice.dart';

void main() {
  var list = [1, 2, 2, 3, 3, 2, 1, 1];
  var slice = list.asSlice();
  var (dedup, duplicates) = slice.partitionDedup();
  print(dedup); // [1, 2, 3, 2, 1]
  print(duplicates); // [2, 3, 1]
}
```

### Copying and Moving

Copy elements within a list or to another list:

```dart
import 'package:rust_core/slice.dart';

void main() {
  var srcList = [1, 2, 3, 4, 5];
  var dstList = [6, 7, 8, 9, 10];
  var src = Slice(srcList, 0, 5);
  var dst = Slice(dstList, 0, 5);
  dst.copyFromSlice(src);
  print(dstList); // [1, 2, 3, 4, 5]
}
```