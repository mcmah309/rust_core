# Convert

## Infallible

`Infallible` is the error type for errors that can never happen. This can be useful for generic APIs that use Result
and parameterize the error type, to indicate that the result is always Ok. Thus these types expose `intoOk` and
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