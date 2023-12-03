import 'package:rust_core/core.dart'; // Or import 'package:rust_core/<LIBRARY_NAME>.dart';

void main() {
  usingTheEarlyReturnKey();
  usingRegularPatternMatching();
}

Result<int, String> usingTheEarlyReturnKey() => Result.$(($) {
      double x = willAlwaysReturnErr()[$];
      return Ok(x.toInt());
    });

Result<int, String> usingRegularPatternMatching() {
  double x;
  switch (willAlwaysReturnErr()) {
    case Err(:final err):
      return Err(err);
    case Ok(:final ok):
      x = ok;
  }
  return Ok(x.toInt());
}

Result<double, String> willAlwaysReturnErr() => Err("error");
