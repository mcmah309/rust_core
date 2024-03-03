import 'package:rust_core/result.dart';
import 'package:rust_core/slice.dart';
import 'package:test/test.dart';
import 'package:rust_core/array.dart';

void main() {
  test("map", () {
    var arr = Array(3, 1);
    var mapped = arr.map((e) => e + 1);
    expect(mapped, [2, 2, 2]);
  });

  test("map", () {
    var arr = Array(3, 1);
    var mapped = arr.map((e) => e + 1);
    expect(mapped, [2, 2, 2]);
  });

  test("rsplit", () {
    var arr = Array(3, 1);
    var rsplit = arr.rsplit(1);
    expect(rsplit.$1, [1, 1]);
    expect(rsplit.$2, [1]);
  });

  test("split", () {
    var arr = Array(3, 1);
    var split = arr.split(1);
    expect(split.$1, [1]);
    expect(split.$2, [1, 1]);
  });

  test("tryMap Ok", () {
    var arr = Array(3, 1);
    var tryMap = arr.tryMap((e) => Ok(e + 1));
    expect(tryMap.unwrap(), [2, 2, 2]);
  });

  test("tryMap Err", () {
    var arr = Array(3, 1);
    var tryMap = arr.tryMap<int,String>((e) {
      if (e == 1) {
        return Err("Error");
      } else {
        return Ok(e + 1);
      }
    });
    expect(tryMap, Err("Error"));
  });
}
