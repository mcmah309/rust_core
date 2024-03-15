import 'package:rust_core/option.dart';
import 'package:rust_core/result.dart';
import 'package:test/test.dart';

void main() {
  test("OptionResultExtension transpose", () async {
    Option<Result<int, String>> someOk = Some(Ok(5));
    expect(someOk.transpose(), Ok(Some(5)));

    Option<Result<int, String>> someErr = Some(Err("Error"));
    expect(someErr.transpose(), Err("Error"));

    Option<Result<int, String>> none = None;
    expect(none.transpose(), Ok(None));

    Option<Result<int?, String>> someOkNull = Some(Ok(null));
    Result<Option<int>, String> res = someOkNull.transpose();
    expect(res, Ok(None));
  });

  test("FutureOptionResultExtension transpose", () async {
    FutureOption<Result<int, String>> someOkOption = Future.value(Some(Ok(5)));
    expect(await someOkOption.transpose(), Ok(Some(5)));

    FutureOption<Result<int, String>> someErrOption =
        Future.value(Some(Err("Error")));
    expect(await someErrOption.transpose(), Err("Error"));

    FutureOption<Result<int, String>> noneOption = Future.value(None);
    expect(await noneOption.transpose(), Ok(None));

    FutureOption<Result<int?, String>> someOkNullOption =
        Future.value(Some(Ok(null)));
    Result<Option<int>, String> res = await someOkNullOption.transpose();
    expect(res, Ok(None));
  });
}
