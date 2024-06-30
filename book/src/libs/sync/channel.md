# channel

rust_core supports two types of channels, "local" channels (same isolate) and "isolate" channels (different isolates).

## Local Channels

`channel` is used for communication between produces and consumers on the **same** isolate. `channel` is
similar to `StreamController` except it buffers data until read and will never throw.
In more detail, `channel` returns a `Sender` and `Receiver`. Each item `T` sent by the `Sender`
will only be seen once by the `Receiver`. If the `Sender` calls `close` while the `Receiver`'s buffer
is not empty, the `Receiver` will still yield the remaining items in the buffer until empty.

### Examples
#### Single Sender, Single Receiver
In this example, a single sender sends data to a single receiver. The receiver retrieves the data and processes it.

```dart
import 'package:rust_core/sync.dart';

void main() async {
  final (tx, rx) = channel<int>();

  // Sender sends data
  tx.send(1);
  tx.send(2);
  tx.send(3);

  // Receiver retrieves data
  for (int i = 0; i < 3; i++) {
    print(await rx.recv()); // Outputs: 1, 2, 3
  }
}
```

### Receiver with Timeout
This example shows how to handle timeouts when receiving data from a channel.

```dart
import 'package:rust_core/sync.dart';

void main() async {
  final (tx, rx) = channel<int>();

  // Sender sends data
  tx.send(1);

  // Receiver retrieves data with a timeout
  final result = await rx.recvTimeout(Duration(milliseconds: 100));
  if (result.isOk()) {
    print(result.unwrap()); // Outputs: 1
  } else {
    print("Timeout"); // If timeout occurs
  }
}
```
### Receiver with Error Handling
In this example, we see how to handle errors that might occur while receiving data from a channel.

```dart
import 'package:rust_core/sync.dart';

void main() async {
  final (tx, rx) = channel<int>();

  // Sender sends data and then an error
  tx.send(1);
  tx.send(2);
  tx.addError(Exception("Test error"));

  // Receiver retrieves data and handles errors
  for (int i = 0; i < 3; i++) {
    final result = await rx.recv();
    if (result.isOk()) {
      print(result.unwrap()); // Outputs: 1, 2
    } else {
      print("Error: ${result.unwrapErr()}"); // Handles error
    }
  }
}
```
### Iterating Over Received Data
This example demonstrates how to iterate over the received data using the iter method.

```dart
import 'package:rust_core/sync.dart';

void main() async {
  final (tx, rx) = channel<int>();

  // Sender sends data
  tx.send(1);
  tx.send(2);
  tx.send(3);

  // Receiver iterates over the data
  final iterator = rx.iter();
  for (final value in iterator) {
    print(value); // Outputs: 1, 2, 3
  }
}
```
### Using Receiver as a Stream
In this example, we see how to use the receiver as a stream, allowing for asynchronous data handling.

```dart
import 'package:rust_core/sync.dart';

void main() async {
  final (tx, rx) = channel<int>();

  // Sender sends data
  tx.send(1);
  tx.send(2);
  tx.send(3);

  // Close the sender after some delay
  () async {
    await Future.delayed(Duration(seconds: 1));
    tx.close();
  }();

  // Receiver processes the stream of data
  await for (final value in rx.stream()) {
    print(value); // Outputs: 1, 2, 3
  }
}
```

## Isolate Channels

`isolateChannel` is used to bi-directional isolate communication with channels. The returned
`Sender` and `Receiver` can communicate with the spawned isolate and 
the spawned isolate is passed a `Sender` and `Receiver` to communicate with the original isolate.
Each item `T` sent by the `Sender` will only be seen once by the `Receiver`. If the `Sender` calls `close` while the `Receiver`'s buffer
is not empty, the `Receiver` will still yield the remaining items in the buffer until empty.
Types that can be sent over a `SendPort` as defined [here](https://api.flutter.dev/flutter/dart-isolate/SendPort/send.html)
are allow to be sent between isolates. Otherwise a `toIsolateCodec` and/or a `fromIsolateCodec` can be passed
to encode and decode the messages.

### Examples

#### Simple String Communication
This example demonstrates a simple string message being sent and received between the main isolate and a spawned isolate.

```dart
void main() async {
  final (tx1, rx1) = await isolateChannel<String, String>((tx2, rx2) async {
    assert((await rx2.recv()).unwrap() == "hello");
    tx2.send("hi");
  }, toIsolateCodec: const StringCodec(), fromIsolateCodec: const StringCodec());

  tx1.send("hello");
  expect((await rx1.recv()).unwrap(), "hi");
}
```
#### Different Codecs for Communication
This example demonstrates using different codecs for communication between the main isolate and a spawned isolate.

```dart
void main() async {
  final (tx1, rx1) = await isolateChannel<String, int>((tx2, rx2) async {
    assert((await rx2.recv()).unwrap() == "hello");
    tx2.send(1);
  }, toIsolateCodec: const StringCodec(), fromIsolateCodec: const IntCodec());

  tx1.send("hello");
  expect((await rx1.recv()).unwrap(), 1);
}
```
#### No Codecs
This example demonstrates communication without specifying codecs, relying on the default codecs.

```dart
void main() async {
  final (tx1, rx1) = await isolateChannel<String, int>((tx2, rx2) async {
    assert((await rx2.recv()).unwrap() == "hello");
    tx2.send(1);
  });

  tx1.send("hello");
  expect((await rx1.recv()).unwrap(), 1);
}
```
#### Bi-directional Send and Receive
This example demonstrates a more complex scenario where multiple messages are sent and received in both directions.

```dart
void main() async {
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
}
```