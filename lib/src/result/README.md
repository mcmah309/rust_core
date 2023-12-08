# Result

### Table Of Contents

- [Result](#result)
    - [What Is a Result Monad Type And Why Use It?](#what-is-a-result-monad-type-and-why-use-it)
    - [Intro to Usage](#intro-to-usage)
        - [Regular Dart Error Handling](#regular-dart-error-handling)
            - [What's Wrong with this Solution?](#whats-wrong-with-this-solution)
        - [Result Type](#result-type)
    - [Adding Predictable Control Flow To Legacy Dart Code](#adding-predictable-control-flow-to-legacy-dart-code)
    - [Dart Equivalent To The Rust "?" Early Return Operator](#dart-equivalent-to-the-rust--early-return-operator)
    - [How to Never Unwrap Incorrectly](#how-to-never-unwrap-incorrectly)
- [Misc](#misc)
    - [Working with Futures](#working-with-futures)
    - [ToResult and ToResultEager](#toresult-and-toresulteager)
        - [Iterable Result](#iterable-result)
        - [Multiple Results of Different Success Types](#multiple-results-of-different-success-types)
    - [Pattern Matching vs Early Return Key](#pattern-matching-vs-early-return-key)

## What Is a Result Monad Type And Why Use it?
A monad is just a wrapper around an object that provides a standard way of interacting with the inner object. The
`Result` monad is used in place of throwing exceptions. Instead of a function throwing an exception, the function
returns a `Result`, which can either be a `Ok` (Success) or `Err` (Error/Failure), `Result` is the type union
between the two. Before unwrapping the inner object, you check the type of the `Result` through conventions like
`case Ok(:final ok)` and `isOk()`. Checking allows you to
either resolve any potential issues in the calling function or pass the error up the chain until a function resolves
the issue. This provides predictable control flow to your program, eliminating many potential bugs and countless
hours of debugging.

## Intro to Usage
### Regular Dart Error handling
```dart
void main() {
  try {
    print(order("Bob", 1));
  } catch(e) {
    print(e);
  }
}

String order(String user, int orderNumber) {
  final result = makeFood(orderNumber);
  return "Order of $result is complete for $user";
}

String makeFood(int orderNumber) {
  if (orderNumber == 1) {
    return makeHamburger();
  }
  return "pasta";
}

String makeHamburger() {
  // Who catches this??
  // How do we know we won't forget to catch this??
  // What is the context around this error??
  throw "Hmm something went wrong making the hamburger.";
}
```
#### What's Wrong with this Solution?
* If we forget to catch in the correct spot, we just introduced a bug or worse - crashed our entire program.
* We may later reuse `makeHamburger`, `makeFood`, or `order`, and forget that it can throw.
* The more we reuse functions 
that can throw, the less maintainable and error-prone our program becomes. 
* Throwing is also an expensive operation, as it requires stack unwinding.

### Result Type
Other languages address the issues with throwing exception by preventing them entirely. Most that do use a
`Result` monad (Some Languages call it `Either`).

```dart
import 'package:rust_core/result.dart';

void main() {
  print(order("Bob", 1));
}

Result<String, String> order(String user, int orderNumber) {
  final result = makeFood(orderNumber);
  if(result case Ok(:final ok)) { // Could also use "if(result.isOk())" or a switch statement
    return Ok("Order of $ok is complete for $user");
  }
  return result;
}

Result<String, String> makeFood(int orderNumber) {
  if (orderNumber == 1) {
    return makeHamburger();
  }
  return Ok("pasta");
}

Result<String,String> makeHamburger() {
  // What is the context around this error??
  return Err("Hmm something went wrong making the hamburger.");
}
```

## Adding Predictable Control Flow To Legacy Dart Code
At times, you may need to integrate with legacy code that may throw or code outside your project. To handle, you 
can just wrap in a helper function like `executeProtected`
```dart
void main() {
  Result<int,Object> result = executeProtected(() => functionWillThrow());
  print(result);
}

int functionWillThrow() {
  throw "this message was thrown";
}
```
Output:
```text
this message was thrown
```

## Dart Equivalent To The Rust "?" Early Return Operator
In Dart, the Rust "?" operator (Early Return Operator) functionality in `x?`, where `x` is a `Result`, can be 
accomplished in two ways
### into()
```dart
if (x case Err()) {
  return x.into(); // may not need "into()"
}
```
`into` may be needed to change the `S` type of `Result<S,F>` for `x` to that of the functions return type if 
they are different.
`into` only exits if after the type check, so you will never mishandle a type change since the compiler will stop you.
Note: There also exists
`intoUnchecked` that does not require implicit cast of a `Result` Type.
### Early Return Key Notation
"Early Return Key Notation" is a take on "Do Notation" and the "Early Return Key"
functions the same way as the "Early Return Operator". The 
Early Return Key is typically denoted with `$` and when 
passed to a Result it unlocks the inner value, or returns to the surrounding context. e.g.
```dart
Result<int, String> innerErrFn() => Err("message");
Result<int, String> earlyReturn() => Result(($) { // Early Return Key
   int y = 2;
   // The function will return here will the Err value;
   int x = innerErrFn()[$];
   return Ok(x.unwrap() + y);
 });

expect(earlyReturn().unwrapErr(), "message");
```
Using the Early Return Key Notation reduces the need for pattern matching or checking, in a safe way. This is quite a 
powerful tool. See [here](#pattern-matching-vs-early-return-key) for another example.

## How to Never Unwrap Incorrectly
In Rust, as here, it is possible to unwrap values that should not be unwrapped:
```dart
if (x.isErr()) {
  return x.unwrap(); // this will panic (should be "unwrapErr()")
}
```
There are two ways to never unwrap incorrectly:
### Pattern Matching
Simple do a typecheck with `is` or `case` instead of `isErr()`.
```dart
if (x case Err(:final err)){
    return err;
}
```
and vice versa
```dart
if (x case Ok(:final ok){
    return ok;
}
```
The type check does an implicit cast, and we now have access to the immutable error and ok value respectively.

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

Or declaratively with `match`
```dart
x.match(
  ok: (ok) => ok,
  err: (err) => err
);
```
Or even with `mapOrElse`.
### Early Return Key
We can also use the [Early Return Key](#early-return-key), which is a very powerful idiomatic approach!
## Misc
### Working with Futures
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
    #discarded_futures: true # Don’t invoke asynchronous functions in non-async blocks.

analyzer:
  errors:
    unawaited_futures: error
    await_only_futures: error
    avoid_void_async: error
    #discarded_futures: error
```
### ToResult and ToResultEager
In various circumstances you just want a single `Result` for these times, think `toResult()` or in some cases 
`toResultEager()`. These extension methods have been added to make life easier.
#### Iterable Result
One of these is on `Iterable<Result<S,F>>`, which can turn into a
`Result<List<S>,List<F>>`. Also, there is `.toResultEager()` which can turn into a single `Result<List<S>,F>`.

```dart
var result = [Ok(1), Ok(2), Ok(3)].toResult();
expect(result.unwrap(), [1, 2, 3]);

result = [Ok<int,int>(1), Err<int,int>(2), Ok<int,int>(3)].toResultEager();
expect(result.unwrapErr(), 2);
```
#### Multiple Results of Different Success Types
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
final result = (boolOk(), intOk(), doubleOk()).toResultEager();
switch(result){
   case Ok(:final ok):
      (a, b, c) = ok;
   case Err():
      return result;
}
/// ... Use a,b,c
```
This also has a `toResult()` method.
### Pattern Matching vs Early Return Key
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