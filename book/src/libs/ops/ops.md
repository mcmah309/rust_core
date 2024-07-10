# Ops

## Range

## RangeBounds

The `RangeBounds` have two uses:
1. `RangeBounds` can be used to get a `Slice` of an `Arr`, `Slice`, or `List`.
```dart
void func(RangeBounds bounds) {
    Arr<int> arr = Arr.range(0, 10);
    Slice<int> slice = arr(bounds);
    expect(slice, equals([4, 5, 6, 7, 8, 9]));
}

func(const RangeFrom(4));
```
The variants are `Range`, `RangeFrom`, `RangeFull`, `RangeInclusive`, `RangeTo`, and `RangeToInclusive`.

2. `RangeBounds` that also implement `IterableRangeBounds` can be iterated over as a generator.
```dart
for(int x in const Range(5, 10)){ // 5, 6, 7, 8, 9
    // code
}
```

### `range` Function

`range` is a convenience function that works the same as the python `range` function.
struct.
```dart
range(end); // == range(0,end);
range(start, end);
range(start, end, step);

for(final x in range(0, 10, 1)){}
// equivalent to
for(final x in range(10)){}
```
Note `Arr.range(..)` also exists as a more efficient method for when it is known collecting the range is needed.