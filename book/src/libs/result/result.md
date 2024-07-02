# Result
***
`Result<T, E>` is the type used for returning and propagating errors. It is an alternative to throwing exceptions. It is a sealed type with the variants, `Ok(T)`, representing success and containing a value, and `Err(E)`, representing error and containing an error value.

To better understand the motivation around the `Result` type refer to this [article](https://mcmah309.github.io/#/blog/the_result_type_in_dart).

## Example
***
By using the `Result` type, there is no web of `try`/`catch` statements to maintain and hidden control flow bugs, all control flow is defined.
```dart
import 'package:rust_core/result.dart';

void main() {
  final result = processOrder("Bob", 2);
  result.match(
    ok: (value) => print("Success: $value"),
    err: (error) => print("Error: $error"),
  );
}

Result<String, String> processOrder(String user, int orderNumber) {
  final result = makeFood(orderNumber);
  if(result case Ok(:final ok)) {
    final paymentResult = processPayment(user);
    if(paymentResult case Ok(ok:final paymentOk)) {
      return Ok("Order of $ok is complete for $user. Payment: $paymentOk");
    }
    return paymentResult;
  }
  return result;
}

Result<String, String> makeFood(int orderNumber) {
  if (orderNumber == 1) {
    return makeHamburger();
  } else if (orderNumber == 2) {
    return makePizza();
  }
  return Err("Invalid order number.");
}

Result<String,String> makeHamburger() {
  return Err("Failed to make the hamburger.");
}

Result<String,String> makePizza() {
  return Ok("pizza");
}

Result<String,String> processPayment(String user) {
  if (user == "Bob") {
    return Ok("Payment successful.");
  }
  return Err("Payment failed.");
}
```

## Chaining
***
Effects on a `Result` can be chained in a safe way without
needing to inspect the type.
```dart
Result<int,String> result = Ok(4);
Result<String, String> finalResult = initialResult
    .map((okValue) => okValue * 2) // Doubling the `Ok` value if present.
    .andThen((okValue) => okValue != 0 ? Ok(10 ~/ okValue) : Err('Division by zero')) // Potentially failing operation.
    .map((okValue) => 'Result is $okValue') // Transforming the successful result into a string.
    .mapErr((errValue) => 'Error: $errValue'); // Transforming any potential error.

// Handling the final `Result`:
finalResult.match(
  ok: (value) => print('Success: $value'),
  err: (error) => print('Failure: $error'),
);
```
See the [docs] for all methods and extensions.

## Adding Predictable Control Flow To Legacy Dart Code
***
At times, you may need to integrate with legacy code that may throw or code outside your project. To handle these situations you can just wrap the code in a helper function like `guard`
```dart
void main() {
  Result<int,Object> result = guard(functionWillThrow).mapErr((e) => "$e but was guarded");
  print(result);
}

int functionWillThrow() {
  throw "this message was thrown";
}
```
Output:
```text
this message was thrown but was guarded
```

## Dart Equivalent To The Rust "?" Early Return Operator
***
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
   // The function will return here
   int x = innerErrFn()[$];
   return Ok(x + y);
 });

expect(earlyReturn().unwrapErr(), "message");
```
Using the Early Return Key Notation reduces the need for pattern matching or checking, in a safe way. This is quite a 
powerful tool. See [here](tips_and_best_practices.md#pattern-matching-vs-early-return-key) for another example.

For async, use the `Result.async` e.g.
```dart
FutureResult<int, String> earlyReturn() => Result.async(($) async {
  ...
});
```

[docs]:https://pub.dev/documentation/rust_core/latest/result/result-library.html