# Panic
As with `Error` in Dart Core, `Panic` represents a state that should never happen and thus should never be caught.
Rust vs Dart Error handling terminology:

| Dart Exception Type | Equivalent in Rust |
|---------------------|--------------------|
| Exception           | Error              |
| Error               | Panic              |

```dart
Result x = Err(1);
if (x.isErr()) {
  return x.unwrap(); // this will throw a Panic (should be "unwrapErr()")
}
```

rust_core was designed with safety in mind. The only time rust_core will ever throw is if you `unwrap` incorrectly (as 
above), in
this case a `Panic`'s can be thrown. But the good news is you should never need to use these
methods. See [How to Never Unwrap Incorrectly]
section to
avoid ever using `unwrap`.

[How to Never Unwrap Incorrectly]:https://github.com/mcmah309/rust_core/tree/master/lib/src/result#how-to-never-unwrap-incorrectly