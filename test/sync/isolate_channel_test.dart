@TestOn('vm')

import 'package:rust_core/ops.dart';
import 'package:rust_core/result.dart';
import 'package:rust_core/sync.dart';
import 'package:test/test.dart';

void main() async {
  group("isolateChannel", () {
    test("Simple isolate channel", () async {
      final (tx1, rx1) = await isolateChannel<String, String>((tx2, rx2) async {
        assert((await rx2.recv()).unwrap() == "hello");
        tx2.send("hi");
      },
          toIsolateCodec: const StringCodec(),
          fromIsolateCodec: const StringCodec());
      tx1.send("hello");
      expect((await rx1.recv()).unwrap(), "hi");
    });

    test("Simple isolate channel different codecs", () async {
      final (tx1, rx1) = await isolateChannel<String, int>((tx2, rx2) async {
        assert((await rx2.recv()).unwrap() == "hello");
        tx2.send(1);
      },
          toIsolateCodec: const StringCodec(),
          fromIsolateCodec: const IntCodec());
      tx1.send("hello");
      expect((await rx1.recv()).unwrap(), 1);
    });

    test("Simple isolate channel no codecs", () async {
      final (tx1, rx1) = await isolateChannel<String, int>((tx2, rx2) async {
        assert((await rx2.recv()).unwrap() == "hello");
        tx2.send(1);
      });
      tx1.send("hello");
      expect((await rx1.recv()).unwrap(), 1);
    });

    test("Bi-directional send and receive", () async {
      final (tx1, rx1) = await isolateChannel<int, int>((tx2, rx2) async {
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
      }, toIsolateCodec: const IntCodec(), fromIsolateCodec: const IntCodec());
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

    test("Error handling in isolate", () async {
      final (tx1, rx1) = await isolateChannel<String, String>((tx2, rx2) async {
        assert((await rx2.recv()).unwrap() == "hello");
        throw Exception("An error occurred");
      },
          toIsolateCodec: const StringCodec(),
          fromIsolateCodec: const StringCodec());

      tx1.send("hello");
      expect((await rx1.recv()).unwrapErr(), DisconnectedError());
    });

    test("Complex data types", () async {
      final (tx1, rx1) =
          await isolateChannel<List<int>, List<int>>((tx2, rx2) async {
        List<int> data = (await rx2.recv()).unwrap();
        data.sort();
        tx2.send(data);
      });

      tx1.send([3, 1, 2]);
      expect((await rx1.recv()).unwrap(), [1, 2, 3]);
    });

    test("Timeouts and delays", () async {
      final (tx1, rx1) = await isolateChannel<int, int>((tx2, rx2) async {
        await Future.delayed(Duration(milliseconds: 500));
        tx2.send((await rx2.recv()).unwrap() * 10);
      }, toIsolateCodec: const IntCodec(), fromIsolateCodec: const IntCodec());

      tx1.send(5);
      final result = await rx1.recv().timeout(Duration(seconds: 1));
      expect(result.unwrap(), 50);
    });

    test("Bidirectional complex data type messages", () async {
      final (tx1, rx1) =
          await isolateChannel<Map<String, int>, Map<String, int>>(
              (tx2, rx2) async {
        var data = (await rx2.recv()).unwrap();
        data["b"] = data["a"]! * 10;
        tx2.send(data);
      });

      tx1.send({"a": 5});
      var response = await rx1.recv();
      expect(response.unwrap(), {"a": 5, "b": 50});
    });

    test("closes when out of scope and isolate ends", () async {
      Future<Receiver> scope() async {
        final (tx1, rx1) = await isolateChannel<int, int>((tx2, rx2) async {
          await Future.delayed(Duration(milliseconds: 100));
          tx2.send((await rx2.recv()).unwrap() * 10);
          final receive = await rx2.recv();
          assert(receive.unwrapErr() == const DisconnectedError());
          //print("isolate received the implicit close");
        },
            toIsolateCodec: const IntCodec(),
            fromIsolateCodec: const IntCodec());
        tx1.send(1);
        return rx1;
      }

      final receiver = await scope();
      expect(receiver.isClosed, false);
      expect(receiver.isBufferEmpty, true);
      // force garbage collection, note will not work when debugging
      for (final i in range(0, 1000)) {
        await Future.delayed(Duration(milliseconds: 1));
        List.filled(i, null);
      }
      expect(receiver.isClosed, true);
      expect(receiver.isBufferEmpty, false);
      expect((await receiver.recv()).unwrap(), 10);
      expect(receiver.isBufferEmpty, true);
      expect(receiver.isClosed, true);
      expect((await receiver.recv()).unwrapErr(), DisconnectedError());
    });
  });
}
