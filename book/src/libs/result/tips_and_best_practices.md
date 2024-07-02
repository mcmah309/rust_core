# Tips and Best Practices

## How to Never Unwrap Incorrectly
***
In Rust, as here, it is possible to unwrap values that should not be unwrapped:
```dart
if (x.isErr()) {
  return x.unwrap(); // this will panic (should be "unwrapErr()")
}
```
There are four ways to never unwrap incorrectly:
### Pattern Matching
Simple do a type check with `is` or `case` instead of `isErr()`.
```dart
if (x case Err(:final err)){
    return err;
}
```
and vice versa
```dart
if (x case Ok(:final ok)){
    return ok;
}
```
The type check does an implicit cast, and we now have access to the immutable error and ok value respectively.
### Switch
Similarly, we can mimic Rust's `match` keyword, with Dart's `switch`
```dart
switch(x){
 case Ok(:final ok):
   print(ok);
 case Err(:final err):
   print(err);
}

final y = switch(x){
  Ok(:final ok) => ok,
  Err(:final err) => err,
};
```
### Declaratively
Or declaratively with `match` or `mapOrElse`
```dart
x.match(
  ok: (ok) => ok,
  err: (err) => err
);
```
### Early Return Key Notation
We can also use the [Early Return Key Notation](result.md#early-return-key-notation), which is a very powerful idiomatic approach.

## Working with Futures
***
When working with `Future`s it is easy to make a mistake like this
```dart
Future.delayed(Duration(seconds: 1)); // Future not awaited
```
Where the future is not awaited. With Result's (Or any wrapped type) it is possible to make this mistake
```dart
await Ok(1).map((n) async => await Future.delayed(Duration(seconds: n))); // Outer "await" has no effect
```
The outer "await" has no effect since the value's type is `Result<Future<void>>` not `Future<Result<void>>`.
To address this use `toFutureResult()`
```dart
await Ok(1).map((n) async => await Future.delayed(Duration(seconds: n))).toFutureResult(); // Works as expected
```
To avoid these issues all together in regular Dart and with wrapped types like `Result`, it is recommended to enable 
these `Future` linting rules in `analysis_options.yaml`
```yaml
linter:
  rules:
    unawaited_futures: true # Future results in async function bodies must be awaited or marked unawaited using dart:async
    await_only_futures: true # "await" should only be used on Futures
    avoid_void_async: true # Avoid async functions that return void. (they should return Future<void>)

analyzer:
  errors:
    unawaited_futures: error
    await_only_futures: error
    avoid_void_async: error
```
## ToResult and ToResultEager
***
In various circumstances you just want a single `Result` for these times, think `toResult()` or in some cases 
`toResultEager()`. These extension methods have been added to make life easier.

## Iterable Result
***
One of these is on `Iterable<Result<S,F>>`, which can turn into a
`Result<List<S>,List<F>>`. Also, there is `.toResultEager()` which can turn into a single `Result<List<S>,F>`.

```dart
var result = [Ok(1), Ok(2), Ok(3)].toResult();
expect(result.unwrap(), [1, 2, 3]);

result = [Ok<int,int>(1), Err<int,int>(2), Ok<int,int>(3)].toResultEager();
expect(result.unwrapErr(), 2);
```
## Multiple Results of Different Success Types
***
Sometimes you need to call multiple functions that return `Result`s of different types. You could write something 
like this:
```dart
final a, b, c;
final boolResult = boolOk();
switch(boolResult){
  case Ok(:final ok):
    a = ok;
  case Err():
    return boolResult;
}
final intResult = intOk();
switch(intResult){
  case Ok(:final ok):
    b = ok;
  case Err():
      return intResult;
}
final doubleResult = doubleOk();
switch(doubleResult){
    case Ok(:final ok):
        c = ok;
    case Err():
        return doubleResult;
}
/// ... Use a,b,c
```
That is a little verbose. Fortunately, extensions to the recuse, instead do:
```dart
final a, b, c;
final result = (boolOk, intOk, doubleOk).toResultEager();
switch(result){
   case Ok(:final ok):
      (a, b, c) = ok;
   case Err():
      return result;
}
/// ... Use a,b,c
```
This also has a `toResult()` method.

## Pattern Matching vs Early Return Key
***
```dart
void main(){
  usingTheEarlyReturnKey();
  usingRegularPatternMatching();
}

Result<int,String> usingTheEarlyReturnKey() => Result(($){ // Early Return Key
  // Will return here with 'Err("error")'
  int x = willAlwaysReturnErr()[$].toInt();
  return Ok(x);
});

Result<int,String> usingRegularPatternMatching(){
  int x;
  switch(willAlwaysReturnErr()){
    case Err(:final err):
      return Err(err);
    case Ok(:final ok):
      x = ok.toInt();
  }
  return Ok(x);
}

Result<double,String> willAlwaysReturnErr() => Err("error");
```