// ignore_for_file: unused_local_variable

import 'package:rust_core/prelude.dart';

void main() {
  usingTheEarlyReturnKeyExample();
  usingRegularPatternMatchingExample();
  usingFunctionChainingExample();
  iteratorExample();
  sliceExample();

  /// Visit the library links to see more!
}

Result<int, String> usingTheEarlyReturnKeyExample() => Result(($) {
      // Early Return Key
      // Will return here with 'Err("error")'
      int x = willAlwaysReturnErr()[$].toInt();
      return Ok(x);
    });

Result<int, String> usingRegularPatternMatchingExample() {
  switch (willAlwaysReturnErr()) {
    case Err(:final err):
      return Err(err);
    case Ok(:final ok):
      return Ok(ok.toInt());
  }
}

Result<int, String> usingFunctionChainingExample() =>
    willAlwaysReturnErr().map((e) => e.toInt());

void iteratorExample() {
  List<int> list = [1, 2, 3, 4, 5, 6, 7, 8, 9];
  RIterator<int> rIterator = list.iter();
  List<int> collect = [];
  for (final e in rIterator.take(5).map((e) => e * e)) {
    if (e.isEven) {
      collect.add(e);
    }
  }
  //expect(collect, [4, 16]);
  Option<int> next = rIterator.next();
  //expect(next, Some(6));
  collect.add(next.unwrap());
  next = rIterator.next();
  collect.add(next.unwrap());
  //expect(next, Some(7));
  while (rIterator.moveNext()) {
    collect.add(rIterator.current * rIterator.current);
  }
  //expect(collect, [4, 16, 6, 7, 64, 81]);
  //expect(rIterator,[]);
}

void sliceExample() {
  var list = [1, 2, 3, 4, 5];
  var slice = Slice(list, 1, 4);
  //expect(slice, [2, 3, 4]);
  var taken = slice.takeLast();
  //expect(taken, 4);
  //expect(slice, [2, 3]);
  slice[1] = 10;
  //expect(list, [1, 2, 10, 4, 5]);
}

Result<double, String> willAlwaysReturnErr() => Err("error");
