#### Null and Unit

In Dart, `void` is used to indicate that a function doesn't return anything or a type should not be used, as such:
```dart
Result<void, void> x = Ok(1); // valid
Result<void, void> y = Err(1); // valid
int z = x.unwrap(); // not valid 
```

Since stricter types are preferred and `Err` cannot be null, use `()` aka `Unit`:

```dart
Unit == ().runtimeType; // true
Result<(), ()> x = Err(unit); // valid
Result<Unit, Unit> y = Err(()); // valid
x == y; // true

// Note:
// const unit = const ();
// const okay = const Ok(unit);
// const error = const Err(unit);
```

#### Infallible

`Infallible` is the error type for errors that can never happen. This can be useful for generic APIs that use Result
and parameterize the error type, to indicate that the result is always Ok.Thus these types expose `intoOk` and
`intoErr`.

```dart

Result<int, Infallible> x = Ok(1);
expect(x.intoOk(), 1);
Result<Infallible, int> w = Err(1);
expect(w.intoErr(), 1);
```

```
typedef Infallible = Never;
```