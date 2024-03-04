# Array

Array is a zero cost extension type of List, where the list is treated as non-growable. This is useful for correctly handling lists where growable is false and const lists, as these types of lists are treated the same in the regular Dart type system, which may lead to errors.
```dart
var array = Array(null, 10);
array = Array.constant(const [1,2,3,4,5]);
for(final entry in array){
    // do something
}
var (slice1, slice2) = array.splitSlice(3);
```
`Array` is not a typical array compared to most other languages - a non-const array will still be on the heap, but the allocation will be more efficient since it does not reserve additional capacity. Which is important since allocations account for most of the cost of using the heap compared to the stack.