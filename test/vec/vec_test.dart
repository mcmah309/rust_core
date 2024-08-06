import 'package:rust_core/slice.dart';
import 'package:rust_core/option.dart';
import 'package:rust_core/vec.dart';
import 'package:test/test.dart';

main() {
  test("append", () {
    Vec<int> vec = [1, 2, 3];
    vec.append([4, 5, 6]);
    expect(vec, [1, 2, 3, 4, 5, 6]);
  });

  test("asSlice", () {
    Vec<int> vec = [1, 2, 3];
    var slice = vec.asSlice();
    expect(slice, [1, 2, 3]);
  });

  test("clear", () {
    Vec<int> vec = [1, 2, 3];
    vec.clear();
    expect(vec, []);
  });

  test("dedup", () {
    Vec<int> vec = [1, 2, 2, 3, 3, 3, 4, 5, 5, 5, 5];
    vec.dedup();
    expect(vec, [1, 2, 3, 4, 5]);
  });

  test("dedupBy", () {
    Vec<int> vec = [1, 2, 2, 3, 3, 3, 4, 5, 5, 5, 5];
    vec.dedupBy((a, b) => a == b);
    expect(vec, [1, 2, 3, 4, 5]);
  });

  test("dedupByKey", () {
    Vec<int> vec = [1, 2, 2, 3, 3, 3, 4, 5, 5, 5, 5];
    vec.dedupByKey((a) => a);
    expect(vec, [1, 2, 3, 4, 5]);
  });

  test("drain", () {
    Vec<int> vec = [1, 2, 3, 4, 5];
    var drained = vec.drain(1, vec.len() - 1);
    expect(drained, [2, 3, 4]);
    expect(vec, [1, 5]);
  });

  test("extendFromSlice", () {
    Vec<int> vec = [1, 2, 3];
    vec.extendFromSlice(Slice([4, 5, 6], 0, 3));
    expect(vec, [1, 2, 3, 4, 5, 6]);
  });

  test("extendFromWithin", () {
    Vec<int> vec = [1, 2, 3];
    vec.extendFromWithin(0, 3);
    expect(vec, [1, 2, 3, 1, 2, 3]);
  });

  test("extractIf", () {
    Vec<int> vec = [1, 2, 3, 4, 5, 6];
    var extracted = vec.extractIf((e) => e % 2 == 0);
    expect(extracted.take(1), [2]);
    expect(vec, [1, 3, 4, 5, 6]);
    expect(extracted.toList(), [4, 6]);
    expect(vec, [1, 3, 5]);
  });

  test("insert", () {
    Vec<int> vec = [1, 2, 3];
    vec.insert(1, 4);
    expect(vec, [1, 4, 2, 3]);
  });

  test("pop", () {
    Vec<int> vec = [1, 2, 3];
    var popped = vec.pop();
    expect(popped, Some(3));
    expect(vec, [1, 2]);
  });

  test("push", () {
    Vec<int> vec = [1, 2, 3];
    vec.push(4);
    expect(vec, [1, 2, 3, 4]);
  });

  test("resize", () {
    Vec<int> vec = [1, 2, 3];
    vec.resize(5, 4);
    expect(vec, [1, 2, 3, 4, 4]);

    vec.resize(2, 4);
    expect(vec, [1, 2]);
  });

  test("resizeWith", () {
    Vec<int> vec = [1, 2, 3];
    vec.resizeWith(5, () => 4);
    expect(vec, [1, 2, 3, 4, 4]);

    vec.resizeWith(2, () => 4);
    expect(vec, [1, 2]);
  });

  test("splice", () {
    Vec<int> vec = [1, 2, 3, 4];
    var spliced = vec.splice(1, 3, [7, 8, 9]);
    expect(vec, [1, 7, 8, 9, 4]);
    expect(spliced, [2, 3]);
  });

  test("splitOff", () {
    Vec<int> vec = [1, 2, 3, 4];
    var split = vec.splitOff(2);
    expect(vec, [1, 2]);
    expect(split, [3, 4]);
  });

  test("swapRemove", () {
    Vec<int> vec = [1, 2, 3, 4];
    vec.swapRemove(1);
    expect(vec, [1, 4, 3]);
  });

  // Slice
  //************************************************************************//

  group("Verify vec slice methods", () {
    test("swap", () {
      Vec<int> vec = [1, 2, 3, 4];
      vec.asSlice().swap(1, 3);
      expect(vec, [1, 4, 3, 2]);
    });
  });

  // Validation
  //************************************************************************//

  test("Ensure can use Option in Vec", () {
    Vec<Option<int>> vec = [Some(1), None, Some(3)];
    var filtered = vec.iter().filter((e) => e.isSome()).map((e) => e.unwrap());
    expect(filtered, [1, 3]);
  });

  test("Ensure can use null in Vec", () {
    Vec<int?> vec = [1, null, 3];
    var filtered = vec.iter().filter((e) => e != null).map((e) => e);
    expect(filtered, [1, 3]);
  });

  test("Can use Vec and List interchangeably", () {
    void list(List<int> y) {}
    void vec(Vec<int> y) {}
    Vec<int> w = [];
    list(w);
    vec(w);
    List<int> x = [];
    list(x);
    vec(x);
    Vec<Vec<int>> i = [[]];
    i.flatten();
  });
}