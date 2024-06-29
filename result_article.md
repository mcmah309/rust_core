Every modern programming language has error handling. Like Python, Dart chose the unchecked try-catch catch pattern, Java went with checked try-catch pattern, Zig went with Error Unions, and Rust went with error handling with the return type.

s the type used for returning and propagating errors. It is an enum with the variants, Ok(T), representing success and containing a value, and Err(E), representing error and containing an error value.

## What Is a Result Monad Type And Why Use it?
A monad is just a wrapper around an object that provides a standard way of interacting with the inner object. The
`Result` monad is used in place of throwing exceptions. Instead of a function throwing an exception, the function
returns a `Result`, which can either be a `Ok` (Success) or `Err` (Error/Failure), `Result` is the type union
between the two. Before unwrapping the inner object, you check the type of the `Result` through conventions like
`case Ok(:final ok)` and `isOk()`. Checking allows you to
either resolve any potential issues in the calling function or pass the error up the chain until a function resolves
the issue. This provides predictable control flow to your program, eliminating many potential bugs and countless
hours of debugging.

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
  return Err("Hmm something went wrong making the hamburger.");
}
```
Now with the `Result` type there are no more undefined
behaviors due to control flow!