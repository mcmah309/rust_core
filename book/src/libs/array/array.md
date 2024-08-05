# Array
***
`Arr` (Array) is a zero cost extension type of `List`, where the `List` is treated as non-growable. This is useful for correctly handling lists where growable is false and const lists - as these types of lists are treated the same in the regular Dart type system, which may lead to errors. With `Arr`, type intent is clear for maintainers and developers are able think about code performance more critically.
```dart
Arr<int?> array = Arr(null, 10);
```
`Arr`'s allocation will be more efficient than compared to a `List` since it does not reserve additional capacity and allocates the full amount eagerly. Which is important since allocations account for most of the cost of the runtime costs of a List.

## Examples

### Creating Arrays

You can create `Arr` instances in several ways:

#### From a Default Value

```dart
var array = Arr(null, 10); // Creates an array of 10 null values
```

#### From a Constant List

```dart
var array = Arr.constant(const [1, 2, 3, 4, 5]); // Creates an array from a constant list
```

#### Using a Generator Function

```dart
var array = Arr.generate(10, (i) => i); // Generates an array with values from 0 to 9
```

#### Creating a Range

```dart
var array = Arr.range(0, 10, step: 2); // Creates an array with values [0, 2, 4, 6, 8]
```

### Accessing Elements

You can access and modify elements just like a normal list:

```dart
var entry = array[2]; // Accesses the element at index 2
array[2] = 10; // Sets the element at index 2 to 10
```

### Iterating Over Elements

You can use a for-in loop to iterate over the elements:

```dart
for (final entry in array) {
  print(entry); // Do something with each entry
}
```

### Converting to List

You can convert `Arr` back to a regular list (this will be erased at compile time so there is no cost):

```dart
var list = array.list;
```

### Splitting Arrays

You can split an array into two slices:

```dart
var (slice1, slice2) = array.splitSlice(3); // Splits the array at index 3
```