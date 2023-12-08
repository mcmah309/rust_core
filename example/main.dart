import 'package:rust_core/core.dart'; // Or import 'package:rust_core/<LIBRARY_NAME>.dart';

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
