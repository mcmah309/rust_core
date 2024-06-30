# Tips

## Null and Unit

In Dart, `void` is used to indicate that a function doesn't return anything or a type should not be used, as such:
```dart
Result<void, void> x = Ok(1); // valid
Result<void, void> y = Err(1); // valid
int z = x.unwrap(); // not valid 
```

Since stricter types are preferred and `Err` cannot be null, use `()` aka "Unit":