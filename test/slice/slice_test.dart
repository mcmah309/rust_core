// ignore_for_file: avoid_types_as_parameter_names

import 'package:rust_core/option.dart';
import 'package:test/test.dart';
import 'package:rust_core/slice.dart';

main() {
  test("copyFromSlice", () {
    var srcList = [1, 2, 3, 4, 5];
    var dstList = [6, 7, 8, 9, 10];
    var src = Slice(srcList, 0, 5);
    var dst = Slice(dstList, 0, 5);
    dst.copyFromSlice(src);
    expect(dstList, [1, 2, 3, 4, 5]);

    srcList = [1, 2, 3, 4, 5];
    dstList = [6, 7, 8, 9, 10];
    src = Slice(srcList, 0, 5);
    dst = Slice(dstList, 1, 4);
    dst.copyFromSlice(src);
    expect(dstList, [6, 1, 2, 3, 10]);

    srcList = [1, 2, 3, 4, 5];
    dstList = [6, 7, 8, 9, 10];
    src = Slice(srcList, 1, 4);
    dst = Slice(dstList, 0, 5);
    dst.copyFromSlice(src);
    expect(dstList, [2, 3, 4, 9, 10]);
  });

  test("endsWith", () {
    var list = [1, 2, 3, 4, 5];
    var slice = Slice(list, 0, 5);
    expect(slice.endsWith([4, 5].asSlice()), true);
    expect(slice.endsWith([3, 4, 5].asSlice()), true);
    expect(slice.endsWith([2, 3, 4, 5].asSlice()), true);
    expect(slice.endsWith([1, 2, 3, 4, 5].asSlice()), true);
    expect(slice.endsWith([0, 1, 2, 3, 4, 5].asSlice()), false);
    expect(slice.endsWith([1, 2, 3, 4].asSlice()), false);
    expect(slice.endsWith([2, 3, 4].asSlice()), false);
    expect(slice.endsWith([3, 4].asSlice()), false);
    expect(slice.endsWith([4].asSlice()), false);
    expect(slice.endsWith([5].asSlice()), true);
    expect(slice.endsWith([1, 2, 3, 4, 5, 6, 7, 8, 9, 10].asSlice()), false);

    list = [1, 2, 3, 4, 5];
    slice = Slice(list, 1, 4);
    expect(slice.endsWith([3, 4].asSlice()), true);
    expect(slice.endsWith([2, 3, 4].asSlice()), true);
    expect(slice.endsWith([1, 2, 3, 4].asSlice()), false);
    expect(slice.endsWith([1, 2, 3, 4, 5].asSlice()), false);
    expect(slice.endsWith([0, 1, 2, 3, 4, 5].asSlice()), false);
    expect(slice.endsWith([1, 2, 3, 4, 5, 6, 7, 8, 9, 10].asSlice()), false);
  });

  test("getMany", () {
    var list = [1, 2, 3, 4, 5];
    var slice = Slice(list, 0, 5);
    expect(slice.getMany(const [0, 1, 2]).unwrap(), [1, 2, 3]);
    expect(slice.getMany(const [0, 1, 2, 3, 4]).unwrap(), [1, 2, 3, 4, 5]);
    expect(slice.getMany(const [1, 3]).unwrap(), [2, 4]);
    expect(slice.getMany(const []).unwrap(), []);
    expect(slice.getMany(const [0, 1, 2, 3, 4, 5]).unwrapErr(),
        GetManyErrorTooManyIndices());
    expect(slice.getMany(const [0, 1, 6]).unwrapErr(),
        GetManyErrorRequestedIndexOutOfBounds());
    expect([].asSlice().getMany(const [0]).unwrapErr(),
        GetManyErrorTooManyIndices());
    expect([].asSlice().getMany(const []).unwrap(), []);
    expect([1].asSlice().getMany(const []).unwrap(), []);
  });

  test("getManyUnchecked", () {
    var list = [1, 2, 3, 4, 5];
    var slice = Slice(list, 0, 5);
    expect(slice.getManyUnchecked(const [0, 1, 2]), [1, 2, 3]);
    expect(slice.getManyUnchecked(const [0, 1, 2, 3, 4]), [1, 2, 3, 4, 5]);
    expect(slice.getManyUnchecked(const [1, 3]), [2, 4]);
    expect(slice.getManyUnchecked(const []), []);
  });

  test("groupBy", () {
    var list = [1, 1, 1, 3, 3, 2, 2, 2];
    var slice = list.asSlice();
    var iter = slice.groupBy((num1, num2) => num1 == num2);
    expect(iter.next().unwrap(), [1, 1, 1]);
    expect(iter.next().unwrap(), [3, 3]);
    expect(iter.next().unwrap(), [2, 2, 2]);
    expect(iter.next().isNone(), true);
  });

  test("isSorted", () {
    var list = [1, 2, 3, 4, 5];
    var slice = Slice(list, 0, 5);
    expect(slice.isSorted(), true);

    list = [1, 2, 3, 4, 5, 3];
    slice = Slice(list, 0, 6);
    expect(slice.isSorted(), false);

    list = [1, 2, 3, 4, 5, 3];
    slice = Slice(list, 0, 5);
    expect(slice.isSorted(), true);
  });

  test("isSortedBy", () {
    var list = [1, 2, 3, 4, 5];
    var slice = Slice(list, 0, 5);
    expect(slice.isSortedBy((a, b) => a.compareTo(b)), true);

    list = [1, 2, 3, 4, 5, 3];
    slice = Slice(list, 0, 6);
    expect(slice.isSortedBy((a, b) => a.compareTo(b)), false);

    list = [1, 2, 3, 4, 5, 3];
    slice = Slice(list, 0, 5);
    expect(slice.isSortedBy((a, b) => a.compareTo(b)), true);
  });

  test("isSortedByKey", () {
    var list = <num>[1, 2, 3, 4, 5];
    var slice = Slice(list, 0, 5);
    expect(slice.isSortedByKey((num) => num), true);

    list = [1, 2, 3, 4, 5, 3];
    slice = Slice(list, 0, 6);
    expect(slice.isSortedByKey((num) => num), false);

    list = [1, 2, 3, 4, 5, 3];
    slice = Slice(list, 0, 5);
    expect(slice.isSortedByKey((num) => num), true);
  });

  test("reverse", () {
    var list = [1, 2, 3, 4, 5];
    var slice = Slice(list, 0, 5);
    slice.reverse();
    expect(list, [5, 4, 3, 2, 1]);

    list = [1, 2, 3, 4, 5];
    slice = Slice(list, 1, 4);
    slice.reverse();
    expect(list, [1, 4, 3, 2, 5]);
  });

  test("takeStart", () {
    var list = [1, 2, 3, 4, 5];
    var slice = Slice(list, 0, 5);
    var taken = slice.takeStart(3);
    expect(taken, [1, 2, 3]);
    expect(list, [1, 2, 3, 4, 5]);

    list = [1, 2, 3, 4, 5];
    slice = Slice(list, 1, 4);
    taken = slice.takeStart(3);
    expect(taken, [2, 3, 4]);
    expect(list, [1, 2, 3, 4, 5]);
  });

  test("takeEnd", () {
    var list = [1, 2, 3, 4, 5];
    var slice = Slice(list, 0, 5);
    var taken = slice.takeEnd(3);
    expect(taken, [3, 4, 5]);
    expect(list, [1, 2, 3, 4, 5]);

    list = [1, 2, 3, 4, 5];
    slice = Slice(list, 1, 4);
    taken = slice.takeEnd(3);
    expect(taken, [2, 3, 4]);
    expect(list, [1, 2, 3, 4, 5]);
  });

  test("takeFirst", () {
    var list = [1, 2, 3, 4, 5];
    var slice = Slice(list, 0, 5);
    var taken = slice.takeFirst();
    expect(taken, 1);
    expect(slice, [2, 3, 4, 5]);

    list = [1, 2, 3, 4, 5];
    slice = Slice(list, 1, 4);
    taken = slice.takeFirst();
    expect(taken, 2);
    expect(slice, [3, 4]);
  });

  test("takeLast", () {
    var list = [1, 2, 3, 4, 5];
    var slice = Slice(list, 0, 5);
    var taken = slice.takeLast();
    expect(taken, 5);
    expect(slice, [1, 2, 3, 4]);

    list = [1, 2, 3, 4, 5];
    slice = Slice(list, 1, 4);
    expect(slice, [2, 3, 4]);
    taken = slice.takeLast();
    expect(taken, 4);
    expect(slice, [2, 3]);

    slice[1] = 10;
    expect(list, [1, 2, 10, 4, 5]);
  });

  test("rsplit", () {
    var list = [11, 22, 33, 0, 44, 55];
    var slice = Slice(list, 0, 6);
    var iter = slice.rsplit((num) => num == 0);
    expect(iter.next().unwrap(), [44, 55]);
    expect(iter.next().unwrap(), [11, 22, 33]);
  });

  test("rsplitAt", () {
    var list = [1, 2, 3, 4, 5];
    var slice = Slice(list, 0, 5);
    var rsplit = slice.rsplitAt(2);
    expect(rsplit.$1, [1, 2, 3]);
    expect(rsplit.$2, [4, 5]);

    list = [1, 2, 3, 4, 5];
    slice = Slice(list, 1, 4);
    rsplit = slice.rsplitAt(2);
    expect(rsplit.$1, [2]);
    expect(rsplit.$2, [3, 4]);

    list = [1, 2, 3, 4, 5];
    slice = Slice(list, 0, 5);
    rsplit = slice.rsplitAt(5);
    expect(rsplit.$1, []);
    expect(rsplit.$2, [1, 2, 3, 4, 5]);

    list = [1, 2, 3, 4, 5];
    slice = Slice(list, 0, 5);
    rsplit = slice.rsplitAt(0);
    expect(rsplit.$1, [1, 2, 3, 4, 5]);
    expect(rsplit.$2, []);
  });

  test("rsplitOnce", () {
    var list = [1, 2, 3, 2, 4];
    expect(list.asSlice().rsplitOnce((num) => num == 2).unwrap().$1, [1, 2, 3]);
    expect(list.asSlice().rsplitOnce((num) => num == 2).unwrap().$2, [4]);
    expect(list.asSlice().rsplitOnce((num) => num == 0).isNone(), true);
    expect(list.asSlice().rsplitOnce((num) => num == 1).unwrap().$1, []);
    expect(
        list.asSlice().rsplitOnce((num) => num == 1).unwrap().$2, [2, 3, 2, 4]);
    expect(
        list.asSlice().rsplitOnce((num) => num == 4).unwrap().$1, [1, 2, 3, 2]);
    expect(list.asSlice().rsplitOnce((num) => num == 4).unwrap().$2, []);
  });

  test("sortUnstable", () {
    var list = [5, 4, 3, 2, 1];
    var slice = Slice(list, 0, 5);
    slice.sortUnstable();
    expect(list, [1, 2, 3, 4, 5]);

    list = [5, 4, 3, 2, 1];
    slice = Slice(list, 1, 4);
    slice.sortUnstable();
    expect(list, [5, 2, 3, 4, 1]);

    var doubleList = [5.0, 4.0, 3.0, 2.0, 1.0];
    var doubleSlice = Slice(doubleList, 0, 5);
    doubleSlice.sortUnstable();

    var stringList = ["b", "a", "d", "c", "e"];
    var stringSlice = Slice(stringList, 0, 5);
    stringSlice.sortUnstable();
    expect(stringList, ["a", "b", "c", "d", "e"]);
  });

  test("sortUnstableBy", () {
    var list = [5, 4, 3, 2, 1];
    var slice = Slice(list, 0, 5);
    slice.sortUnstableBy((a, b) => a.compareTo(b));
    expect(list, [1, 2, 3, 4, 5]);

    list = [5, 4, 3, 2, 1];
    slice = Slice(list, 1, 4);
    slice.sortUnstableBy((a, b) => a.compareTo(b));
    expect(list, [5, 2, 3, 4, 1]);

    var doubleList = [5.0, 4.0, 3.0, 2.0, 1.0];
    var doubleSlice = Slice(doubleList, 0, 5);
    doubleSlice.sortUnstableBy((a, b) => a.compareTo(b));

    var stringList = ["b", "a", "d", "c", "e"];
    var stringSlice = Slice(stringList, 0, 5);
    stringSlice.sortUnstableBy((a, b) => a.compareTo(b));
    expect(stringList, ["a", "b", "c", "d", "e"]);
  });

  test("sortUnstableByKey", () {
    var list = <num>[5, 4, 3, 2, 1];
    var slice = Slice(list, 0, 5);
    slice.sortUnstableByKey((num) => num);
    expect(list, [1, 2, 3, 4, 5]);

    list = [5, 4, 3, 2, 1];
    slice = Slice(list, 1, 4);
    slice.sortUnstableByKey((num) => num);
    expect(list, [5, 2, 3, 4, 1]);

    var doubleList = [5.0, 4.0, 3.0, 2.0, 1.0];
    var doubleSlice = Slice(doubleList, 0, 5);
    doubleSlice.sortUnstableByKey<num>((num) => num);

    var stringList = ["b", "a", "d", "c", "e"];
    var stringSlice = Slice(stringList, 0, 5);
    stringSlice.sortUnstableByKey((str) => str);
    expect(stringList, ["a", "b", "c", "d", "e"]);
  });

  test("split", () {
    var list = [10, 40, 33, 20];
    var iter = Slice(list, 0, 4).split((num) => num % 3 == 0);
    expect(iter.next().unwrap(), [10, 40]);
    expect(iter.next().unwrap(), [20]);
    expect(iter.next().isNone(), true);
  });

  test("splitAt", () {
    var list = [1, 2, 3, 4, 5];
    var slice = Slice(list, 0, 5);
    var split = slice.splitAt(2);
    expect(split.$1, [1, 2]);
    expect(split.$2, [3, 4, 5]);

    list = [1, 2, 3, 4, 5];
    slice = Slice(list, 1, 4);
    split = slice.splitAt(2);
    expect(split.$1, [2, 3]);
    expect(split.$2, [4]);

    list = [1, 2, 3, 4, 5];
    slice = Slice(list, 0, 5);
    split = slice.splitAt(5);
    expect(split.$1, [1, 2, 3, 4, 5]);
    expect(split.$2, []);

    list = [1, 2, 3, 4, 5];
    slice = Slice(list, 0, 5);
    split = slice.splitAt(0);
    expect(split.$1, []);
    expect(split.$2, [1, 2, 3, 4, 5]);
  });

  test("splitFirst", () {
    var list = [1, 2, 3, 2, 4];
    expect(list.asSlice().splitFirst().unwrap().$1, 1);
    expect(list.asSlice().splitFirst().unwrap().$2, [2, 3, 2, 4]);
    list = [1];
    expect(list.asSlice().splitFirst().unwrap().$1, 1);
    expect(list.asSlice().splitFirst().unwrap().$2, []);
    list = [];
    expect(list.asSlice().splitFirst().isNone(), true);
  });

  test("splitInclusive", () {
    var list = [10, 40, 33, 20];
    var iter = Slice(list, 0, 4).splitInclusive((num) => num % 3 == 0);
    expect(iter.next().unwrap(), [10, 40, 33]);
    expect(iter.next().unwrap(), [20]);
    expect(iter.next().isNone(), true);
  });

  test("splitLast", () {
    var list = [1, 2, 3, 2, 4];
    expect(list.asSlice().splitLast().unwrap().$1, 4);
    expect(list.asSlice().splitLast().unwrap().$2, [1, 2, 3, 2]);
    list = [1];
    expect(list.asSlice().splitLast().unwrap().$1, 1);
    expect(list.asSlice().splitLast().unwrap().$2, []);
    list = [];
    expect(list.asSlice().splitLast().isNone(), true);
  });

  test("splitOnce", () {
    var list = [1, 2, 3, 2, 4];
    expect(list.asSlice().splitOnce((num) => num == 2).unwrap().$1, [1]);
    expect(list.asSlice().splitOnce((num) => num == 2).unwrap().$2, [3, 2, 4]);
    expect(list.asSlice().splitOnce((num) => num == 0).isNone(), true);
    expect(list.asSlice().splitOnce((num) => num == 1).unwrap().$1, []);
    expect(
        list.asSlice().splitOnce((num) => num == 1).unwrap().$2, [2, 3, 2, 4]);
    expect(
        list.asSlice().splitOnce((num) => num == 4).unwrap().$1, [1, 2, 3, 2]);
    expect(list.asSlice().splitOnce((num) => num == 4).unwrap().$2, []);
  });

  test("splitn", () {
    var list = [10, 40, 33, 20];
    var iter = Slice(list, 0, 4).splitn(2, (num) => num % 3 == 0);
    expect(iter.next().unwrap(), [10, 40]);
    expect(iter.next().unwrap(), [20]);
    expect(iter.next().isNone(), true);

    iter = Slice(list, 0, 4).splitn(1, (num) => num % 3 == 0);
    expect(iter.next().unwrap(), [10, 40, 33, 20]);

    iter = Slice(list, 0, 4).splitn(2, (num) => num % 5 == 0);
    expect(iter.next().unwrap(), []);
    expect(iter.next().unwrap(), [40, 33, 20]);

    iter = Slice(list, 0, 4).splitn(5, (num) => num % 5 == 0);
    expect(iter.next().unwrap(), []);
    expect(iter.next().unwrap(), []);
    expect(iter.next().unwrap(), [33]);
    expect(iter.next().unwrap(), []);
    expect(iter.next().isNone(), true);

    list = [10, 40, 30, 20, 60, 50];
    iter = Slice(list, 0, 6).splitn(2, (num) => num % 3 == 0);
    expect(iter.next().unwrap(), [10, 40]);
    expect(iter.next().unwrap(), [20, 60, 50]);
  });

  test("startsWith", () {
    var list = [1, 2, 3, 4, 5];
    var slice = Slice(list, 0, 5);
    expect(slice.startsWith([1, 2].asSlice()), true);
    expect(slice.startsWith([1, 2, 3].asSlice()), true);
    expect(slice.startsWith([1, 2, 3, 4].asSlice()), true);
    expect(slice.startsWith([1, 2, 3, 4, 5].asSlice()), true);
    expect(slice.startsWith([1, 2, 3, 4, 5, 6].asSlice()), false);
    expect(slice.startsWith([1, 2, 3, 4, 6].asSlice()), false);
    expect(slice.startsWith([1, 2, 3, 5].asSlice()), false);
    expect(slice.startsWith([1, 2, 4].asSlice()), false);
    expect(slice.startsWith([1, 3].asSlice()), false);
    expect(slice.startsWith([2].asSlice()), false);
    expect(slice.startsWith([1, 2, 3, 4, 5, 6, 7, 8, 9, 10].asSlice()), false);

    list = [1, 2, 3, 4, 5];
    slice = Slice(list, 1, 4);
    expect(slice.startsWith([2, 3].asSlice()), true);
    expect(slice.startsWith([2, 3, 4].asSlice()), true);
    expect(slice.startsWith([2, 3, 4, 5].asSlice()), false);
    expect(slice.startsWith([2, 3, 4, 5, 6].asSlice()), false);
    expect(slice.startsWith([2, 3, 4, 6].asSlice()), false);
    expect(slice.startsWith([2, 3, 5].asSlice()), false);
    expect(slice.startsWith([2, 4].asSlice()), false);
    expect(slice.startsWith([3].asSlice()), false);
    expect(slice.startsWith([2, 3, 4, 5, 6, 7, 8, 9, 10].asSlice()), false);
  });

  test("stripPrefix", () {
    var list = [1, 2, 3, 4, 5];
    var slice = Slice(list, 0, 5);
    expect(slice.stripPrefix(<int>[].asSlice()).unwrap(), [1, 2, 3, 4, 5]);
    expect(slice.stripPrefix([1].asSlice()).unwrap(), [2, 3, 4, 5]);
    expect(slice.stripPrefix([1, 2].asSlice()).unwrap(), [3, 4, 5]);
    expect(slice.stripPrefix([1, 2, 3].asSlice()).unwrap(), [4, 5]);
    expect(slice.stripPrefix([1, 2, 3, 4].asSlice()).unwrap(), [5]);
    expect(slice.stripPrefix([1, 2, 3, 4, 5].asSlice()).unwrap(), []);
    expect(slice.stripPrefix([1, 2, 3, 4, 5, 6].asSlice()).isNone(), true);
    expect(slice.stripPrefix([1, 2, 3, 4, 6].asSlice()).isNone(), true);
    expect(slice.stripPrefix([1, 2, 3, 5].asSlice()).isNone(), true);
    expect(slice.stripPrefix([1, 2, 4].asSlice()).isNone(), true);
    expect(slice.stripPrefix([1, 3].asSlice()).isNone(), true);
    expect(slice.stripPrefix([2].asSlice()).isNone(), true);
    expect(
        slice.stripPrefix([1, 2, 3, 4, 5, 6, 7, 8, 9, 10].asSlice()).isNone(),
        true);

    list = [1, 2, 3, 4, 5];
    slice = Slice(list, 1, 4);
    expect(slice.stripPrefix(<int>[].asSlice()).unwrap(), [2, 3, 4]);
    expect(slice.stripPrefix([2, 3].asSlice()).unwrap(), [4]);
    expect(slice.stripPrefix([2, 3, 4].asSlice()).unwrap(), []);
    expect(slice.stripPrefix([2, 3, 4, 5].asSlice()).isNone(), true);
    expect(slice.stripPrefix([2, 3, 4, 5, 6].asSlice()).isNone(), true);
    expect(slice.stripPrefix([2, 3, 4, 6].asSlice()).isNone(), true);
    expect(slice.stripPrefix([2, 3, 5].asSlice()).isNone(), true);
    expect(slice.stripPrefix([2, 5].asSlice()).isNone(), true);
  });

  test("stripSuffix", () {
    var list = [1, 2, 3, 4, 5];
    var slice = Slice(list, 0, 5);
    expect(slice.stripSuffix(<int>[].asSlice()).unwrap(), [1, 2, 3, 4, 5]);
    expect(slice.stripSuffix([5].asSlice()).unwrap(), [1, 2, 3, 4]);
    expect(slice.stripSuffix([4, 5].asSlice()).unwrap(), [1, 2, 3]);
    expect(slice.stripSuffix([3, 4, 5].asSlice()).unwrap(), [1, 2]);
    expect(slice.stripSuffix([2, 3, 4, 5].asSlice()).unwrap(), [1]);
    expect(slice.stripSuffix([1, 2, 3, 4, 5].asSlice()).unwrap(), []);
    expect(slice.stripSuffix([0, 1, 2, 3, 4, 5].asSlice()).isNone(), true);
    expect(slice.stripSuffix([1, 2, 3, 4, 6].asSlice()).isNone(), true);
    expect(slice.stripSuffix([0, 2, 3, 5].asSlice()).isNone(), true);
    expect(slice.stripSuffix([1, 2, 4].asSlice()).isNone(), true);
    expect(slice.stripSuffix([1, 3].asSlice()).isNone(), true);
    expect(slice.stripSuffix([2].asSlice()).isNone(), true);
    expect(
        slice.stripSuffix([1, 2, 3, 4, 5, 6, 7, 8, 9, 10].asSlice()).isNone(),
        true);

    list = [1, 2, 3, 4, 5];
    slice = Slice(list, 1, 4);
    expect(slice.stripSuffix(<int>[].asSlice()).unwrap(), [2, 3, 4]);
    expect(slice.stripSuffix([4].asSlice()).unwrap(), [2, 3]);
    expect(slice.stripSuffix([3, 4].asSlice()).unwrap(), [2]);
    expect(slice.stripSuffix([2, 3, 4].asSlice()).unwrap(), []);
  });

  test("swap", () {
    var list = [1, 2, 3, 4, 5];
    var slice = Slice(list, 0, 5);
    slice.swap(0, 4);
    expect(list, [5, 2, 3, 4, 1]);

    list = [1, 2, 3, 4, 5];
    slice = Slice(list, 1, 4);
    slice.swap(0, 2);
    expect(list, [1, 4, 3, 2, 5]);
  });

  test("swapWithSlice", () {
    var list = [1, 2, 3, 4, 5];
    var slice = Slice(list, 0, 5);
    var other = Slice([6, 7, 8, 9, 10], 0, 5);
    slice.swapWithSlice(other);
    expect(list, [6, 7, 8, 9, 10]);
    expect(other, [1, 2, 3, 4, 5]);

    list = [1, 2, 3, 4, 5];
    slice = Slice(list, 1, 4);
    var otherList = [6, 7, 8, 9, 10];
    other = Slice(otherList, 2, 5);
    slice.swapWithSlice(other);
    expect(list, [1, 8, 9, 10, 5]);
    expect(slice, [8, 9, 10]);
    expect(otherList, [6, 7, 2, 3, 4]);
    expect(other, [2, 3, 4]);
  });

  test("windows", () {
    var list = [1, 2, 3, 4, 5];
    var slice = Slice(list, 0, 5);
    var windows = slice.windows(2);
    expect(windows, [
      [1, 2],
      [2, 3],
      [3, 4],
      [4, 5]
    ]);

    list = [1, 2, 3, 4, 5];
    slice = Slice(list, 1, 4);
    windows = slice.windows(2);
    expect(windows, [
      [2, 3],
      [3, 4]
    ]);

    list = [1, 2, 3, 4, 5];
    slice = Slice(list, 0, 5);
    windows = slice.windows(5);
    expect(windows, [
      [1, 2, 3, 4, 5]
    ]);
  });
}
