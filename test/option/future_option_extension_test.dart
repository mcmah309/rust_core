
import 'dart:async';
import 'package:rust_core/option.dart';
import 'package:test/test.dart';

void main() {
  group('FutureOptionExtension Tests', () {
    test("flatten", () async {
      FutureOption<Option<int>> someSome6 = Future.value(Some(Some(6)));
      expect(await someSome6.flatten(), Some(6));

      FutureOption<Option<int>> someNone = Future.value(const Some(None()));
      expect(await someNone.flatten(), const None());

      FutureOption<Option<int>> none = Future.value(const None());
      expect(await none.flatten(), const None());

      // Flattening only removes one level of nesting at a time
      FutureOption<Option<Option<int>>> someSomeSome6 = Future.value(Some(Some(Some(6))));
      expect(await someSomeSome6.flatten(), Some(Some(6)));
      expect(await someSomeSome6.flatten().flatten(), Some(6));
    });

    test("unzip", () async {
      FutureOption<(int, String)> x = Future.value(Some((1, "hi")));
      var unzippedX = await x.unzip();
      expect(unzippedX.$1, Some(1));
      expect(unzippedX.$2, Some("hi"));

      FutureOption<(int, int)> y = Future.value(const None());
      var unzippedY = await y.unzip();
      expect(unzippedY.$1, const None());
      expect(unzippedY.$1, const None());
    });
  });
}
