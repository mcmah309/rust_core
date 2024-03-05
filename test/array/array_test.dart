import 'package:rust_core/iter.dart';
import 'package:rust_core/result.dart';
import 'package:test/test.dart';
import 'package:rust_core/array.dart';

void main() {
  test("map", () {
    var arr = Arr(1, 3);
    var mapped = arr.map((e) => e + 1);
    expect(mapped, [2, 2, 2]);
  });

  test("map", () {
    var arr = Arr(1, 3);
    var mapped = arr.map((e) => e + 1);
    expect(mapped, [2, 2, 2]);
  });

  test("rsplitSlice", () {
    var arr = Arr(1, 3);
    var rsplit = arr.rsplitSlice(1);
    expect(rsplit.$1, [1, 1]);
    expect(rsplit.$2, [1]);

    rsplit = arr.rsplitSlice(0);
    expect(rsplit.$1, [1, 1, 1]);
    expect(rsplit.$2, []);

    rsplit = arr.rsplitSlice(3);
    expect(rsplit.$1, []);
    expect(rsplit.$2, [1, 1, 1]);
  });

  test("splitSlice", () {
    var arr = Arr(1, 3);
    var split = arr.splitSlice(1);
    expect(split.$1, [1]);
    expect(split.$2, [1, 1]);

    split = arr.splitSlice(0);
    expect(split.$1, []);
    expect(split.$2, [1, 1, 1]);

    split = arr.splitSlice(3);
    expect(split.$1, [1, 1, 1]);
    expect(split.$2, []);
  });

  test("tryMap Ok", () {
    var arr = Arr(1, 3);
    var tryMap = arr.tryMap((e) => Ok(e + 1));
    expect(tryMap.unwrap(), [2, 2, 2]);
  });

  test("tryMap Err", () {
    var arr = Arr(1, 3);
    var tryMap = arr.tryMap<int, String>((e) {
      if (e == 1) {
        return Err("Error");
      } else {
        return Ok(e + 1);
      }
    });
    expect(tryMap, Err("Error"));
  });

  //************************************************************************//
  test("Array and List composability",(){
    Arr<int> arr = Arr(1, 3);
    List<String> list = ["1", "1", "1"];
    final other = arr.iter().zip(list);
    RIterator<int> other2 = arr.iter();
    
  });
}
