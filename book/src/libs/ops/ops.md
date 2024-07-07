# Ops

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
Note `Arr.range(..)` also exists as a more efficient method for when it is known collecting the range is needed.