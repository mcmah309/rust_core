import 'dart:async';
import 'package:rust_core/option.dart';
import 'package:rust_core/result.dart';
import 'package:test/test.dart';

void main() {
  group('Future Extensions Tests', () {
    test("FutureOptionOnResultExtension unwrapOrOption", () async {
      FutureResult<int, String> okResult = Future.value(Ok(5));
      expect(await okResult.unwrapOrOption(), Some(5));

      FutureResult<int, String> errResult = Future.value(Err("Error"));
      expect(await errResult.unwrapOrOption(), None);
    });

    test("FutureResultOptionExtension transpose", () async {
      FutureResult<Option<int>, String> okSomeResult =
          Future.value(Ok(Some(5)));
      expect(await okSomeResult.transpose(), Some(Ok(5)));

      FutureResult<Option<int>, String> okNoneResult = Future.value(Ok(None));
      expect(await okNoneResult.transpose(), None);

      FutureResult<Option<int>, String> errResult = Future.value(Err("Error"));
      expect(await errResult.transpose(), Some(Err("Error")));
    });

    test("FutureOptionResultExtension transpose", () async {
      FutureOption<Result<int, String>> someOkOption =
          Future.value(Some(Ok(5)));
      expect(await someOkOption.transpose(), Ok(Some(5)));

      FutureOption<Result<int, String>> someErrOption =
          Future.value(Some(Err("Error")));
      expect(await someErrOption.transpose(), Err("Error"));

      FutureOption<Result<int, String>> noneOption = Future.value(None);
      expect(await noneOption.transpose(), Ok(None));
    });
  });
}
