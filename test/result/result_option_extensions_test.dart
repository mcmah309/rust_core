import 'dart:async';
import 'package:rust_core/option.dart';
import 'package:rust_core/result.dart';
import 'package:test/test.dart';

void main() {
  test("ResultOptionExtension transpose", () {
    Result<Option<int>, String> okSomeResult = Ok(Some(5));
    expect(okSomeResult.transpose(), Some(Ok(5)));

    Result<Option<int>, String> okNoneResult = Ok(None);
    expect(okNoneResult.transpose(), None);

    Result<Option<int>, String> errResult = Err("Error");
    expect(errResult.transpose(), Some(Err("Error")));

    Result<Option<int?>, String> okNullResult = Ok(None);
    Option<Result<int, String>> res = okNullResult.transpose();
    expect(res, None);
  });

  test("FutureResultOptionExtension transpose", () async {
    FutureResult<Option<int>, String> okSomeResult = Future.value(Ok(Some(5)));
    expect(await okSomeResult.transpose(), Some(Ok(5)));

    FutureResult<Option<int>, String> okNoneResult = Future.value(Ok(None));
    expect(await okNoneResult.transpose(), None);

    FutureResult<Option<int>, String> errResult = Future.value(Err("Error"));
    expect(await errResult.transpose(), Some(Err("Error")));

    FutureResult<Option<int?>, String> okNullResult = Future.value(Ok(None));
    Option<Result<int, String>> res = await okNullResult.transpose();
    expect(res, None);
  });
}
