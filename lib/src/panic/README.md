# Panic
As with `Error` in Dart Core, `Panic` represents a state that should never happen and thus should never be caught.
Rust vs Dart Error handling terminology:

| Dart Exception Type | Equivalent in Rust |
|---------------------|--------------------|
| Exception           | Error              |
| Error               | Panic              |

Thus, here `Error` implements Dart core `Exception` (Not to be confused with the
Dart core `Error` type) and `Panic` implements Dart core `Error`.
```dart
Result x = Err(1);
if (x.isErr()) {
  return x.unwrap(); // this will throw a Panic (should be "unwrapErr()")
}
```

Rust core was designed with safety in mind. The only time anyhow will ever throw is if you `unwrap` incorrectly (as 
above), in
this case a `Panic`'s can be thrown. See 
[How to Never Unwrap Incorrectly](https://github.com/mcmah309/rust_core#how-to-never-unwrap-incorrectly) section to
avoid ever using `unwrap`.