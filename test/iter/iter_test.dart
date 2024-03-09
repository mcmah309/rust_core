import 'package:rust_core/iter.dart';
import 'package:rust_core/slice.dart';
import 'package:rust_core/src/array/array_extensions.dart';
import 'package:test/test.dart';
import 'package:rust_core/option.dart';

main() {

  test("arrayChunks",(){
    var list = [1, 2, 3, 4, 5, 6, 7, 8, 9];
    var chunks = list.iter().arrayChunks(3);
    final x = chunks.collectArr();
    expect(chunks.toList(), [
      [1, 2, 3],
      [4, 5, 6],
      [7, 8, 9]
    ]);

    var chunksIterator = list.iter().arrayChunks(3).iterator;
    while (chunksIterator.moveNext()) {}
    var remainder = chunksIterator.intoRemainder();
    expect(remainder.isNone(), true);    

    var chunks2 = list.iter().arrayChunks(4);
    expect(chunks2.toList(), [
      [1, 2, 3, 4],
      [5, 6, 7, 8],
    ]);

    var chunksIterator2 = list.iter().arrayChunks(4).iterator;
    while (chunksIterator2.moveNext()) {}
    var remainder2 = chunksIterator2.intoRemainder();
    expect(remainder2.unwrap(), [9]);
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


  test("maxBy",(){
    var list = [1, 2, 3, 4, 5];
    var max = list.iter().maxBy((int a, int b) => a.compareTo(b));
    expect(max, Some(5));
  });

  test("maxByKey", (){
    var list = [1, 2, 3, 4, 5];
    var max = list.iter().maxByKey<num>((int a) => a);
    expect(max, Some(5));
  });

  test("minBy",(){
    var list = [1, 2, 3, 4, 5];
    var min = list.iter().minBy((int a, int b) => a.compareTo(b));
    expect(min, Some(1));
  });

  test("minByKey", (){
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

  test("peekable",(){
    var list = [1, 2, 3, 4, 5];
    PeekableIterator<int> peekable = list.iter().peekable().iterator;
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
    var zipped = list.iter().zip([6, 7, 8, 9, 10]);
    expect(zipped, [
      (1, 6),
      (2, 7),
      (3, 8),
      (4, 9),
      (5, 10),
    ]);
    var zipped2 = list.iter().zip([6, 7, 8, 9]);
    expect(zipped2, [
      (1, 6),
      (2, 7),
      (3, 8),
      (4, 9),
    ]);
    var zipped3 = list.iter().zip([6, 7, 8, 9, 10, 11]);
    expect(zipped3, [
      (1, 6),
      (2, 7),
      (3, 8),
      (4, 9),
      (5, 10),
    ]);
    var zipped4 = list.iter().zip([]);
    expect(zipped4, []);
    var zipped5 = [].iter().zip([6, 7, 8, 9, 10]);
    expect(zipped5, []);
  });

  //************************************************************************//

  test("Can take slice", () {
    var list = [1, 2, 3, 4, 5];
    var slice = Slice(list, 1, 3);
    var iter = RIterator<int>(slice);
    iter = RIterator(slice);
    RIterator<int> iter2 = RIterator(slice);
    expect(slice, [2, 3]);
  });
}
