import 'package:rust_core/iter.dart';
import 'package:rust_core/slice.dart';
import 'package:test/test.dart';
import 'package:rust_core/option.dart';

main() {
  test("advanceBy", () {
    var list = [1, 2, 3, 4, 5];
    var iter = list.iter();
    var advanced = iter.advanceBy(2);
    expect(advanced.isOk(), true);
    expect(iter, [3, 4, 5]);
    iter = list.iter();
    var advanced2 = iter.advanceBy(0);
    expect(advanced2.isOk(), true);
    expect(iter, [1, 2, 3, 4, 5]);
    iter = list.iter();
    var advanced3 = iter.advanceBy(5);
    expect(advanced3.isOk(), true);
    expect(iter, []);
    iter = list.iter();
    var advanced4 = iter.advanceBy(6);
    expect(advanced4.unwrapErr(), 1);
    expect(iter, []);
    iter = list.iter();
    list = [];
    iter = list.iter();
    var advanced5 = iter.advanceBy(6);
    expect(advanced5.unwrapErr(), 6);
    expect(iter, []);
    iter = list.iter();
    var set = {1, 2, 3, 4, 5};
    iter = set.iter();
    var advanced6 = iter.advanceBy(2);
    expect(advanced6.isOk(), true);
    expect(iter, [3, 4, 5]);
    iter = set.iter();
    var advanced7 = iter.advanceBy(0);
    expect(advanced7.isOk(), true);
    expect(iter, [1, 2, 3, 4, 5]);
    iter = set.iter();
    var advanced8 = iter.advanceBy(5);
    expect(advanced8.isOk(), true);
    expect(iter, []);
    iter = set.iter();
    var advanced9 = iter.advanceBy(6);
    expect(advanced9.unwrapErr(), 1);
    expect(iter, []);
    iter = set.iter();
    set = {};
    iter = set.iter();
    var advanced10 = iter.advanceBy(6);
    expect(advanced10.unwrapErr(), 6);
    expect(iter, []);
  });

  test("arrayChunks", () {
    var list = [1, 2, 3, 4, 5, 6, 7, 8, 9];
    var chunks = list.iter().arrayChunks(3);
    final newChunkList = chunks.toList();
    expect(newChunkList, [
      [1, 2, 3],
      [4, 5, 6],
      [7, 8, 9]
    ]);

    var chunksIterator = list.iter().arrayChunks(3);
    while (chunksIterator.moveNext()) {}
    var remainder = chunksIterator.intoRemainder();
    expect(remainder.isNone(), true);

    var chunks2 = list.iter().arrayChunks(4);
    expect(chunks2.toList(), [
      [1, 2, 3, 4],
      [5, 6, 7, 8],
    ]);

    var chunksIterator2 = list.iter().arrayChunks(4);
    while (chunksIterator2.moveNext()) {}
    var remainder2 = chunksIterator2.intoRemainder();
    expect(remainder2.unwrap(), [9]);
  });

  test("chain",(){
    var list = [1, 2, 3, 4, 5];
    var list2 = [6, 7, 8, 9, 10];
    var chained = list.iter().chain(list2.iter());
    expect(chained, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);

    var list3 = [1, 2, 3, 4, 5];
    var list4 = <int>[];
    var chained2 = list3.iter().chain(list4.iter());
    expect(chained2, [1, 2, 3, 4, 5]);

    var list5 = <int>[];
    var list6 = [6, 7, 8, 9, 10];
    var chained3 = list5.iter().chain(list6.iter());
    expect(chained3, [6, 7, 8, 9, 10]);
  });

  test("cycle", () {
    var list = [1, 2, 3, 4, 5];
    var cycled = list.iter().cycle().take(10);
    expect(cycled, [1, 2, 3, 4, 5, 1, 2, 3, 4, 5]);
  });

  test("cmp", () {
    var list = [1, 2, 3, 4, 5];
    var list2 = [1, 2, 3, 4, 5];
    var list3 = [1, 2, 3, 4, 6];
    var list4 = [1, 2, 3, 4];
    var list5 = [1, 2, 3, 4, 5, 6];
    expect(list.iter().cmp(list2.iter()), 0);
    expect(list.iter().cmp(list3.iter()), -1);
    expect(list.iter().cmp(list4.iter()), 1);
    expect(list.iter().cmp(list5.iter()), -1);
  });

  test("cmpBy", () {
    var list = [1, 2, 3, 4, 5];
    var list2 = [1, 2, 3, 4, 5];
    var list3 = [1, 2, 3, 4, 6];
    var list4 = [1, 2, 3, 4];
    var list5 = [1, 2, 3, 4, 5, 6];
    expect(list.iter().cmpBy(list2.iter(), (int a, int b) => a.compareTo(b)), 0);
    expect(list.iter().cmpBy(list3.iter(), (int a, int b) => a.compareTo(b)), -1);
    expect(list.iter().cmpBy(list4.iter(), (int a, int b) => a.compareTo(b)), 1);
    expect(list.iter().cmpBy(list5.iter(), (int a, int b) => a.compareTo(b)), -1);
  });

  test("eq", () {
    var list = [1, 2, 3, 4, 5];
    var list2 = [1, 2, 3, 4, 5];
    var list3 = [1, 2, 3, 4, 6];
    var list4 = [1, 2, 3, 4];
    var list5 = [1, 2, 3, 4, 5, 6];
    expect(list.iter().eq(list2.iter()), true);
    expect(list.iter().eq(list3.iter()), false);
    expect(list.iter().eq(list4.iter()), false);
    expect(list.iter().eq(list5.iter()), false);
  });

  test("eqBy", () {
    var list = [1, 2, 3, 4, 5];
    var list2 = [1, 2, 3, 4, 5];
    var list3 = [1, 2, 3, 4, 6];
    var list4 = [1, 2, 3, 4];
    var list5 = [1, 2, 3, 4, 5, 6];
    expect(list.iter().eqBy(list2.iter(), (int a, int b) => a.compareTo(b) == 0), true);
    expect(list.iter().eqBy(list3.iter(), (int a, int b) => a.compareTo(b) == 0), false);
    expect(list.iter().eqBy(list4.iter(), (int a, int b) => a.compareTo(b) == 0), false);
    expect(list.iter().eqBy(list5.iter(), (int a, int b) => a.compareTo(b) == 0), false);
  });

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
      return None;
    });
    expect(filtered, [4, 8]);
  });

  test("fuse", () {
    var list = <Option<int>>[Some(1), Some(2), None, Some(4), Some(5)];
    var fused = list.iter().fuse();
    expect(fused, [1, 2]);
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
      return None;
    });
    expect(found, Some(4));
  });

  test("intersperse", () {
    var list = [1, 2, 3, 4, 5];
    var interspersed = list.iter().intersperse(0);
    expect(interspersed, [1, 0, 2, 0, 3, 0, 4, 0, 5]);

    var list2 = [1];
    var interspersed2 = list2.iter().intersperse(0);
    expect(interspersed2, [1]);

    var list3 = <int>[];
    var interspersed3 = list3.iter().intersperse(0);
    expect(interspersed3, []);
  });

  test("intersperseWith", () {
    var list = [1, 2, 3, 4, 5];
    int count = 0;
    var interspersed = list.iter().intersperseWith(() {
      count++;
      return 0;
    });
    expect(interspersed, [1, 0, 2, 0, 3, 0, 4, 0, 5]);
    expect(count, 4);

    var list2 = [1];
    count = 0;
    var interspersed2 = list2.iter().intersperseWith(() {
      count++;
      return 0;
    });
    expect(interspersed2, [1]);
    expect(count, 0);

    var list3 = <int>[];
    count = 0;
    var interspersed3 = list3.iter().intersperseWith(() {
      count++;
      return 0;
    });
    expect(interspersed3, []);
    expect(count, 0);
  });

  test("isPartitioned",(){
    var list = [1, 2, 3, 4, 5];
    var isPartitioned = list.iter().isPartitioned((e) => e % 2 == 0);
    expect(isPartitioned, false);

    var list2 = [2, 4, 6, 8, 10];
    var isPartitioned2 = list2.iter().isPartitioned((e) => e % 2 == 0);
    expect(isPartitioned2, true);

    var list3 = [1, 3, 6, 8, 10];
    var isPartitioned3 = list3.iter().isPartitioned((e) => e % 2 == 0);
    expect(isPartitioned3, false);

    var list4 = [6, 8, 10, 1, 3];
    var isPartitioned4 = list4.iter().isPartitioned((e) => e % 2 == 0);
    expect(isPartitioned4, true);
  });

  test("isSorted",(){
    var list = <num>[1, 2, 3, 4, 5];
    var isSorted = list.iter().isSorted();
    expect(isSorted, true);

    var list2 = <num>[1, 2, 3, 4, 5, 4];
    var isSorted2 = list2.iter().isSorted();
    expect(isSorted2, false);

    var list3 = <num>[5, 4, 3, 2, 1];
    var isSorted3 = list3.iter().isSorted();
    expect(isSorted3, false);

    var list4 = <num>[1, 2, 3, 4, 5, 5];
    var isSorted4 = list4.iter().isSorted();
    expect(isSorted4, true);
  });

  test("isSortedBy",(){
    var list = <num>[1, 2, 3, 4, 5];
    var isSorted = list.iter().isSortedBy((a, b) => a.compareTo(b));
    expect(isSorted, true);

    var list2 = <num>[1, 2, 3, 4, 5, 4];
    var isSorted2 = list2.iter().isSortedBy((a, b) => a.compareTo(b));
    expect(isSorted2, false);

    var list3 = <num>[5, 4, 3, 2, 1];
    var isSorted3 = list3.iter().isSortedBy((a, b) => a.compareTo(b));
    expect(isSorted3, false);

    var list4 = <num>[1, 2, 3, 4, 5, 5];
    var isSorted4 = list4.iter().isSortedBy((a, b) => a.compareTo(b));
    expect(isSorted4, true);
  });

  test("isSortedByKey",(){
    var list = <num>[1, 2, 3, 4, 5];
    var isSorted = list.iter().isSortedByKey<num>((a) => a);
    expect(isSorted, true);

    var list2 = <num>[1, 2, 3, 4, 5, 4];
    var isSorted2 = list2.iter().isSortedByKey<num>((a) => a);
    expect(isSorted2, false);

    var list3 = <num>[5, 4, 3, 2, 1];
    var isSorted3 = list3.iter().isSortedByKey<num>((a) => a);
    expect(isSorted3, false);

    var list4 = <num>[1, 2, 3, 4, 5, 5];
    var isSorted4 = list4.iter().isSortedByKey<num>((a) => a);
    expect(isSorted4, true);
  });

  test("ge",(){
    var list = [1, 2, 3, 4, 5];
    var list2 = [1, 2, 3, 4, 5];
    var list3 = [1, 2, 3, 4, 6];
    var list4 = [1, 2, 3, 4];
    var list5 = [1, 2, 3, 4, 5, 6];
    expect(list.iter().ge(list2.iter()), true);
    expect(list.iter().ge(list3.iter()), false);
    expect(list.iter().ge(list4.iter()), true);
    expect(list.iter().ge(list5.iter()), false);
  });

  test("gt",(){
    var list = [1, 2, 3, 4, 5];
    var list2 = [1, 2, 3, 4, 5];
    var list3 = [1, 2, 3, 4, 6];
    var list4 = [1, 2, 3, 4];
    var list5 = [1, 2, 3, 4, 5, 6];
    expect(list.iter().gt(list2.iter()), false);
    expect(list.iter().gt(list3.iter()), false);
    expect(list.iter().gt(list4.iter()), true);
    expect(list.iter().gt(list5.iter()), false);
  });

  test("le",(){
    var list = [1, 2, 3, 4, 5];
    var list2 = [1, 2, 3, 4, 5];
    var list3 = [1, 2, 3, 4, 6];
    var list4 = [1, 2, 3, 4];
    var list5 = [1, 2, 3, 4, 5, 6];
    expect(list.iter().le(list2.iter()), true);
    expect(list.iter().le(list3.iter()), true);
    expect(list.iter().le(list4.iter()), false);
    expect(list.iter().le(list5.iter()), true);
  });

  test("lt",(){
    var list = [1, 2, 3, 4, 5];
    var list2 = [1, 2, 3, 4, 5];
    var list3 = [1, 2, 3, 4, 6];
    var list4 = [1, 2, 3, 4];
    var list5 = [1, 2, 3, 4, 5, 6];
    expect(list.iter().lt(list2.iter()), false);
    expect(list.iter().lt(list3.iter()), true);
    expect(list.iter().lt(list4.iter()), false);
    expect(list.iter().lt(list5.iter()), true);
  });

  test("maxBy", () {
    var list = [1, 2, 3, 4, 5];
    var max = list.iter().maxBy((int a, int b) => a.compareTo(b));
    expect(max, Some(5));
  });

  test("maxByKey", () {
    var list = [1, 2, 3, 4, 5];
    var max = list.iter().maxByKey<num>((int a) => a);
    expect(max, Some(5));
  });

  test("minBy", () {
    var list = [1, 2, 3, 4, 5];
    var min = list.iter().minBy((int a, int b) => a.compareTo(b));
    expect(min, Some(1));
  });

  test("minByKey", () {
    var list = [1, 2, 3, 4, 5];
    var min = list.iter().minByKey<num>((int a) => a);
    expect(min, Some(1));
  });

  test("mapWhile", () {
    var list = [1, 2, 3, 4, 5];
    var mapped = list.iter().mapWhile((e) {
      if (e < 4) {
        return Some(e);
      }
      return None;
    });
    expect(mapped, [1, 2, 3]);
  });

  test("mapWindows", () {
    var list = [1, 2, 3, 4];
    var mapped = list.iter().mapWindows(2, (window) => window[0] + window[1]).toList();
    expect(mapped, [3, 5, 7]);

    var list2 = [1, 2, 3, 4, 5];
    var mapped2 = list2.iter().mapWindows(3, (window) => window[0] + window[1] + window[2]).toList();
    expect(mapped2, [6, 9, 12]);
  });

  test("peekable", () {
    var list = [1, 2, 3, 4, 5];
    Peekable<int> peekable = list.iter().peekable();
    expect(peekable.peek(), Some(1));
    expect(peekable.next(), Some(1));
    expect(peekable.peek(), Some(2));
    expect(peekable.peek(), Some(2));
    expect(peekable.next(), Some(2));
    expect(peekable.peek(), Some(3));
    expect(peekable.next(), Some(3));
    expect(peekable.peek(), Some(4));
    expect(peekable.next(), Some(4));
    expect(peekable.peek(), Some(5));
    expect(peekable.next(), Some(5));
    expect(peekable.peek(), None);
    expect(peekable.next(), None);
  });

  test("position", () {
    var list = [1, 2, 3, 4, 5];
    var pos = list.iter().position((e) => e == 2);
    expect(pos, Some(1));
  });

  test("rposition", () {
    var list = [1, 2, 3, 4, 5];
    var rpos = list.iter().rposition((e) => e == 2);
    expect(rpos, Some(1));
  });

  test("unzip", () {
    var list = [(1, 2), (3, 4), (5, 6)];
    var unzipped = list.iter().unzip();
    expect(unzipped.$1, [1, 3, 5]);
    expect(unzipped.$2, [2, 4, 6]);

    var list2 = <(int, double)>[];
    var unzipped2 = list2.iter().unzip();
    expect(unzipped2.$1, []);
    expect(unzipped2.$2, []);
  });

  test("zip", () {
    var list = [1, 2, 3, 4, 5];
    var zipped = list.iter().zip([6, 7, 8, 9, 10].iterator);
    expect(zipped, [
      (1, 6),
      (2, 7),
      (3, 8),
      (4, 9),
      (5, 10),
    ]);
    var zipped2 = list.iter().zip([6, 7, 8, 9].iterator);
    expect(zipped2, [
      (1, 6),
      (2, 7),
      (3, 8),
      (4, 9),
    ]);
    var zipped3 = list.iter().zip([6, 7, 8, 9, 10, 11].iterator);
    expect(zipped3, [
      (1, 6),
      (2, 7),
      (3, 8),
      (4, 9),
      (5, 10),
    ]);
    var zipped4 = list.iter().zip([].iterator);
    expect(zipped4, []);
    var zipped5 = [].iter().zip([6, 7, 8, 9, 10].iterator);
    expect(zipped5, []);
  });

  //************************************************************************//

  test("cast",(){
    var list = [1, 2, 3, 4, 5];
    var casted = list.iter().cast<num>();
    expect(casted, [1.0, 2.0, 3.0, 4.0, 5.0]);
  });

  test("expand",(){
    var list = [1, 2, 3, 4, 5];
    var expanded = list.iter().expand((e) => [e, e]);
    expect(expanded, [1, 1, 2, 2, 3, 3, 4, 4, 5, 5]);
  });

  test("followedBy",(){
    var list = [1, 2, 3, 4, 5];
    var followedBy = list.iter().followedBy([6, 7, 8, 9, 10]);
    expect(followedBy, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
  });

  test("map",(){
    var list = [1, 2, 3, 4, 5];
    var mapped = list.iter().map((e) => e * e);
    expect(mapped, [1, 4, 9, 16, 25]);
  });

  test("skip",(){
    var list = [1, 2, 3, 4, 5];
    var skipped = list.iter().skip(3);
    expect(skipped, [4, 5]);
  });

  test("skipWhile",(){
    var list = [1, 2, 3, 4, 5];
    var skipped = list.iter().skipWhile((e) => e < 3);
    expect(skipped, [3, 4, 5]);
  });

  test("take", (){
    var list = [1, 2, 3, 4, 5];
    final original = list.iter();
    var taken = original.take(3);
    expect(taken, [1, 2, 3]);
    expect(original, [4, 5]);
  });

  test("takeWhile",(){
    var list = [1, 2, 3, 4, 5];
    var taken = list.iter().takeWhile((e) => e < 3);
    expect(taken, [1, 2]);
  });

  test("where",(){
    var list = [1, 2, 3, 4, 5];
    var where = list.iter().where((e) => e % 2 == 0);
    expect(where, [2, 4]);
  });

  test("whereType",(){
    var list = [1, 2, 3, 4, 5];
    var whereType = list.iter().whereType<int>();
    expect(whereType, [1, 2, 3, 4, 5]);

    var list2 = [1, 2, 3, 4, 5, "6"];
    var whereType2 = list2.iter().whereType<int>();
    expect(whereType2, [1, 2, 3, 4, 5]);
  });

  //************************************************************************//

  test("Can take slice", () {
    var list = [1, 2, 3, 4, 5];
    var slice = Slice(list, 1, 3);
    var iter = RIterator<int>(slice.iterator);
    iter = RIterator(slice.iterator);
    RIterator<int> iter2 = RIterator(slice.iterator);
    expect(slice, [2, 3]);
  });

  test("RIterator is a union of Iterable and Iterator",(){
    final list = [1, 2, 3, 4, 5, 6, 7, 8, 9];
    final rIterator = list.iter();
    final collect = [];
    for (final e in rIterator.take(5).map((e) => e * e)) {
      if (e.isEven) {
        collect.add(e);
      }
    }
    expect(collect, [4, 16]);
    Option<int> next = rIterator.next();
    expect(next, Some(6));
    collect.add(next);
    next = rIterator.next();
    collect.add(next);
    expect(next, Some(7));
    while(rIterator.moveNext()){
      collect.add(rIterator.current * rIterator.current);
    }
    expect(collect, [4, 16, 6, 7, 64, 81]);
    expect(rIterator, []);
  });
}
