# Ops

## Range

## Range Class

TDB

### range function

`range` is a convenience function that works the same as the python `range` function, which is similar to Rust's `Range`
struct. In more detail, 
`range` is a generator over a range by a step size.
If `end` is not provided, range will be `0..startOrEnd`, where `startOrEnd` can be positive or negative.
If `step` is not provided, step will be `-1` if `0 > startOrEnd` and `1` if `0 < startOrEnd`.
```dart
range(end); // == range(0,end);
range(start, end);
range(start, end, step);

for(final x in range(0, 10, 1)){}
// equivalent to
for(final x in range(10)){}
```
Note `Arr.range(..)` also exists as a more efficient method for when it is known collecting the range is needed.