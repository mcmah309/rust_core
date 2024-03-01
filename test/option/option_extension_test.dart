import 'package:rust_core/option.dart';
import 'package:test/test.dart';

void main() {
  // test("flatten", () {
  //   Option<Option<int>> someSome6 = Some(Some(6));
  //   expect(someSome6.flatten(), Some(6));

  //   Option<Option<int>> someNone = const Some(None());
  //   expect(someNone.flatten(), const None());

  //   Option<Option<int>> none = const None();
  //   expect(none.flatten(), const None());

  //   // Flattening only removes one level of nesting at a time
  //   Option<Option<Option<int>>> someSomeSome6 = Some(Some(Some(6)));
  //   expect(someSomeSome6.flatten(), Some(Some(6)));
  //   expect(someSomeSome6.flatten().flatten(), Some(6));
  // });

  test("unzip", () {
    Option<(int, String)> x = Some((1, "hi"));
    var unzippedX = x.unzip();
    expect(unzippedX.$1, Some(1));
    expect(unzippedX.$2, Some("hi"));

    Option<(int, int)> y = const None();
    var unzippedY = y.unzip();
    expect(unzippedY.$1, const None());
    expect(unzippedY.$2, const None());
  });
}
