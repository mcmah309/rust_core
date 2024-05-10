import 'package:rust_core/mpsc.dart';
import 'package:test/test.dart';

void main() {
  test("Single sender single reciever", () async {
    List<int> results1 = [];
    List<int> results2 = [];
    final (tx, rx) = channel<int>();
    tx.send(1);
    tx.send(2);
    tx.send(3);
    tx.send(4);
    tx.send(5);
    await Future.delayed(Duration(milliseconds: 100));
    for (int i = 0; i < 2; i++) {
      results1.add((await rx.recv()).unwrap());
      await Future.delayed(Duration(milliseconds: 100));
      results2.add((await rx.recv()).unwrap());
    }
    await Future.delayed(Duration(milliseconds: 100));
    tx.send(6);
    await Future.delayed(Duration(milliseconds: 100));
    results1.add((await rx.recv()).unwrap());
    await Future.delayed(Duration(milliseconds: 100));
    results2.add((await rx.recv()).unwrap());
    await Future.delayed(Duration(milliseconds: 100));
    tx.send(7);
    await Future.delayed(Duration(milliseconds: 100));
    results1.add((await rx.recv()).unwrap());

    expect(results1, [1, 3, 5, 7]);
    expect(results2, [2, 4, 6]);
  });

  test("Single sender multiple reciever", () async {
    List<int> results1 = [];
    List<int> results2 = [];
    final (tx, rx) = channel<int>();
    tx.send(1);
    tx.send(2);
    tx.send(3);
    tx.send(4);
    await Future.delayed(Duration(milliseconds: 100));
    for (int i = 0; i < 2; i++) {
      final r1 = rx.recv();
      final r2 = rx.recv();
      final rs = await Future.wait([r1, r2]);
      results1.add(rs[0].unwrap());
      await Future.delayed(Duration(milliseconds: 100));
      results2.add(rs[1].unwrap());
    }
    tx.send(5);
    block() async {
      final r1 = rx.recv();
      final r2 = rx.recv();
      final rs = await Future.wait([r1, r2]);
      results1.add(rs[0].unwrap());
      await Future.delayed(Duration(milliseconds: 100));
      results2.add(rs[1].unwrap());
      return;
    }

    final b = block();
    await Future.delayed(Duration(milliseconds: 100));
    tx.send(6);
    await Future.delayed(Duration(milliseconds: 100));
    await b;

    expect(results1, [1, 3, 5]);
    expect(results2, [2, 4, 6]);
  });

  test("Receiver with timeout", () async {
    List<int> results = [];
    final (tx, rx) = channel<int>();
    tx.send(1);
    await Future.delayed(Duration(milliseconds: 50));
    final result = await rx.recvTimeout(Duration(milliseconds: 100));
    results.add(result.unwrap());

    final timeoutResult = await rx.recvTimeout(Duration(milliseconds: 50));
    expect(timeoutResult.isErr(), true);
    expect(timeoutResult.unwrapErr(), isA<TimeoutError>());

    expect(results, [1]);
  });

  test("Receiver with error handling", () async {
    List<int> results = [];
    final (tx, rx) = channel<int>();
    tx.send(1);
    tx.send(2);
    tx.addError(Exception("Test error"));
    tx.send(3);
    await Future.delayed(Duration(milliseconds: 100));
    bool foundError = false;
    for (int i = 0; i < 4; i++) {
      final result = await rx.recv();
      if (result.isOk()) {
        results.add(result.unwrap());
      } else {
        final err = result.unwrapErr();
        foundError = true;
        expect(err, isA<OtherError>());
        expect(i, 2);
      }
    }
    expect(foundError, true);
    expect(results, [1, 2, 3]);
  });

  test("Receiver iter method", () async {
    final (tx, rx) = channel<int>();
    tx.send(1);
    tx.send(2);
    tx.send(3);
    tx.send(4);
    await Future.delayed(Duration(milliseconds: 100));

    final iterator = rx.iter();
    List<int> results = [];
    for (final value in iterator) {
      results.add(value);
    }
    expect(results, [1, 2, 3, 4]);
    tx.send(5);
    final value = await rx.recv();
    expect(value.unwrap(), 5);
  });

  test("Receiver stream method", () async {
    final (tx, rx) = channel<int>();
    tx.send(1);
    tx.send(2);
    tx.send(3);
    await Future.delayed(Duration(milliseconds: 100));
    tx.send(4);
    () async {
      await Future.delayed(Duration(milliseconds: 1000));
      tx.close();
    }();

    List<int> results = [];
    await for (final value in rx.stream()) {
      results.add(value);
    }
    expect(results, [1, 2, 3, 4]);
    bool threw = false;
    try {
      tx.send(5);
    } catch (e) {
      threw = true;
      expect(e, isA<StateError>());
    }
    expect(threw, true);
    final value = await rx.recv();
    expect(value.unwrapErr(), DisconnectedError());
  });
}
