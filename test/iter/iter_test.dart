import 'dart:math';

import 'package:rust_core/iter.dart';
import 'package:rust_core/slice.dart';
import 'package:test/test.dart';
import 'package:rust_core/option.dart';

main() {
  test("filter", () {
    var list = [1, 2, 3, 4, 5];
    var filtered = list.iter().filter((e) => e % 2 == 0);
    expect(filtered, [2, 4]);
  });

  test("filterMap", () {
    var list = [1, 2, 3, 4, 5];
    var filtered = list.iter().filterMap((e) {
      if (e % 2 == 0) {
        return Some(e * 2);
      }
      return None();
    });
    expect(filtered, [4, 8]);
  });

  test("find", () {
    var list = [1, 2, 3, 4, 5];
    var found = list.iter().find((e) => e == 3);
    expect(found, Some(3));
  });

  test("findMap", () {
    var list = [1, 2, 3, 4, 5];
    var found = list.iter().findMap((e) {
      if (e % 2 == 0) {
        return Some(e * 2);
      }
      return None();
    });
    expect(found, Some(4));
  });
}
