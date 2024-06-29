library result;

export 'src/result/guard.dart';
export 'src/result/record_to_result_extensions.dart';
export 'src/result/result.dart';
export 'src/result/result_extensions.dart';

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
  // Simulate a successful pizza making process
  return Ok("pizza");
}

Result<String,String> processPayment(String user) {
  if (user == "Bob") {
    return Ok("Payment successful.");
  }
  return Err("Payment failed.");
}
