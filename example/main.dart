// ignore_for_file: unused_local_variable

import 'package:rust_core/rust_core.dart';

void main() {
  usingTheEarlyReturnKeyExample();
  usingRegularPatternMatchingExample();
  usingFunctionChainingExample();
  iteratorExample();
  sliceExample();

  /// Visit the book to see more!
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
  Option<int> next = rIterator.next();
  collect.add(next.unwrap());
  next = rIterator.next();
  collect.add(next.unwrap());
  while (rIterator.moveNext()) {
    collect.add(rIterator.current * rIterator.current);
  }
}

void sliceExample() {
  var list = [1, 2, 3, 4, 5];
  var slice = Slice(list, 1, 4);
  var taken = slice.takeLast();
  slice[1] = 10;
  assert(list[2] == 10);
}

Result<double, String> willAlwaysReturnErr() => Err("error");
