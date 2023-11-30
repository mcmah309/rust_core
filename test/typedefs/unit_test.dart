
import 'package:rust_core/rust_core.dart';
import 'package:test/test.dart';

void main(){
  test("Unit", () {
    Result<Unit, void> x = Ok(());
    Result<(), void> y = Ok(unit);
    expect(x, y);
    Result<void, Unit> a = Err(());
    Result<Unit, ()> b = Err(unit);
    expect(a, b);
  });
}