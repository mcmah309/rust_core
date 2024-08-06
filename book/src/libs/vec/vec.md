# Vec

Vec adds additional extension methods for `List` and adds a `Vec` type - a typedef of `List`. 
`Vec` is used to specifically denote a contiguous **growable** array,
unlike `List` which is growable or non-growable, which may cause runtime exceptions. `Vec` being a typedef of 
`List` means it can be used completely interchangeably.
```dart
Vec<int> vec = [1, 2, 3, 4];
// easily translate back and forth
List<int> list = vec;
vec = list;
```
`Vec` is a nice compliment to [Arr](../array/array.md) (array) type. `Vec` is not included in 
`'package:rust_core/rust_core.dart'` instead it is included included in `'package:rust_core/vec.dart'`.

## Usage

```dart
import 'package:rust_core/rust_core.dart';
import 'package:rust_core/vec.dart';

void main() {
  Vec<int> vec = [1, 2, 3, 4];

  Vec<int> replaced = vec.splice(1, 3, [5, 6]);
  print(replaced); // [2, 3]
  print(vec); // [1, 5, 6, 4]

  vec.push(5);
  vec.insert(2, 99);

  int removed = vec.removeAt(1);
  print(removed); // 5
  print(vec); // [1, 99, 6, 4, 5]

  vec.resize(10, 0);
  print(vec); // [1, 99, 6, 4, 5, 0, 0, 0, 0, 0]

  RIterator<int> iterator = vec.extractIf((element) => element % 2 == 0);
  Vec<int> extracted = iterator.collectVec();
  print(extracted); // [6, 4, 0, 0, 0, 0, 0]
  print(vec); // [1, 99, 5]

  Slice<int> slice = vec.asSlice();
}
```