import 'package:test/test.dart';
import 'package:rust_core/slice.dart';

main(){

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

  test("isSortedBy",(){
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

  test("swap", (){
    var list = [1, 2, 3, 4, 5];
    var slice = Slice(list, 0, 5);
    slice.swap(0, 4);
    expect(list, [5, 2, 3, 4, 1]);

    list = [1, 2, 3, 4, 5];
    slice = Slice(list, 1, 4);
    slice.swap(0, 2);
    expect(list, [1, 4, 3, 2, 5]);
  });

  test("swapWithSlice", (){
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
    expect(windows, [[1, 2], [2, 3], [3, 4], [4, 5]]);

    list = [1, 2, 3, 4, 5];
    slice = Slice(list, 1, 4);
    windows = slice.windows(2);
    expect(windows, [[2, 3], [3, 4]]);

    list = [1, 2, 3, 4, 5];
    slice = Slice(list, 0, 5);
    windows = slice.windows(5);
    expect(windows, [[1, 2, 3, 4, 5]]);
  });
}