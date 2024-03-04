import 'package:rust_core/option.dart';
import 'package:rust_core/result.dart';
import 'package:test/test.dart';

void main() {
  test("ResultOnOptionExtension unwrapOrOption", () {
    Result<int, String> okResult = Ok(5);
    expect(okResult.unwrapOrOption(), Some(5));

    Result<int, String> errResult = Err("Error");
    expect(errResult.unwrapOrOption(), None);
  });

  test("OkOnOptionExtension unwrapOrOption", () {
    Ok<int, String> okResult = Ok(5);
    expect(okResult.unwrapOrOption(), Some(5));
  });

  test("ErrOnOptionExtension unwrapOrOption", () {
    Err<int, String> errResult = Err("Error");
    expect(errResult.unwrapOrOption(), None);
  });

  test("ResultOptionExtension transpose", () {
    Result<Option<int>, String> okSomeResult = Ok(Some(5));
    expect(okSomeResult.transpose(), Some(Ok(5)));

    Result<Option<int>, String> okNoneResult = Ok(None);
    expect(okNoneResult.transpose(), None);

    Result<Option<int>, String> errResult = Err("Error");
    expect(errResult.transpose(), Some(Err("Error")));
  });

  test("OptionResultExtension transpose", () {
    Option<Result<int, String>> someOkOption = Some(Ok(5));
    expect(someOkOption.transpose(), Ok(Some(5)));

    Option<Result<int, String>> someErrOption = Some(Err("Error"));
    expect(someErrOption.transpose(), Err("Error"));

    Option<Result<int, String>> noneOption = None;
    expect(noneOption.transpose(), Ok(None));
  });
}
