# Array
***
`Arr` (Array) is a zero cost extension type of `List`, where the `List` is treated as non-growable. This is useful for correctly handling lists where growable is false and const lists - as these types of lists are treated the same in the regular Dart type system, which may lead to errors. With `Arr`, type intent is clear for maintainers and developers are able think about code performance more critically.
```dart
var array = Arr(null, 10);
array = Arr.constant(const [1,2,3,4,5]);
array = Arr.generate(10, (i) => i);
for(final entry in array){
    // do something
}
var (slice1, slice2) = array.splitSlice(3);
```
`Arr`'s allocation will be more efficient than compared to a `List` since it does not reserve additional capacity and allocates the full amount eagerly. Which is important since allocations account for most of the cost of the runtime costs of a List.

## Range

`range` is a convenience function for an iterator over the range `[start..end)`, where `start >= end` or `start <= end`.
```dart
for(final x in range(0, 10).stepBy(2)){
    // code
}
// or equivalent
for(final x in (0, 10).stepBy(2)){
    // code
}
```

`rangeArr` also exists as a more efficient method for when it is known collecting the range is needed.
```dart
Arr<int> x = rangeArr(0, 10, step: 2);
```