import 'package:rust_core/src/result/result.dart';
import 'package:rust_core/sync.dart';
import 'package:test/test.dart';

void main() async {
  test("Simple isolate channel", () async {
    final (tx1, rx1) = await isolateChannel<String>(const StringCodec(), (tx2, rx2) async {
      assert((await rx2.recv()).unwrap() == "hello");
      tx2.send("hi");
    });
    tx1.send("hello");
    expect((await rx1.recv()).unwrap(), "hi");
  });

  test("Bi-directional send and receive", () async {
    final (tx1, rx1) = await isolateChannel<int>(const IntCodec(), (tx2, rx2) async {
      await Future.delayed(Duration(milliseconds: 100));
      tx2.send((await rx2.recv()).unwrap() * 10);
      await Future.delayed(Duration(milliseconds: 100));
      tx2.send((await rx2.recv()).unwrap() * 10);
      await Future.delayed(Duration(milliseconds: 100));
      tx2.send(6);
      await Future.delayed(Duration(milliseconds: 100));
      tx2.send((await rx2.recv()).unwrap() * 10);
      await Future.delayed(Duration(milliseconds: 100));
      tx2.send((await rx2.recv()).unwrap() * 10);
      await Future.delayed(Duration(milliseconds: 100));
      tx2.send(7);
      await Future.delayed(Duration(milliseconds: 100));
      tx2.send((await rx2.recv()).unwrap() * 10);
    });
    tx1.send(1);
    expect(await rx1.recv().unwrap(), 10);
    tx1.send(2);
    expect(await rx1.recv().unwrap(), 20);
    tx1.send(3);
    expect(await rx1.recv().unwrap(), 6);
    tx1.send(4);
    expect(await rx1.recv().unwrap(), 30);
    tx1.send(5);
    expect(await rx1.recv().unwrap(), 40);
    expect(await rx1.recv().unwrap(), 7);
    expect(await rx1.recv().unwrap(), 50);
  });
}
