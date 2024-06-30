# channel

`channel` is similar to `StreamController` except it buffers data until read and will never throw.
In more detail, `channel` returns a `Sender` and `Receiver`. Each item `T` sent by the `Sender`
will only be seen once by the `Receiver`. If the `Sender` calls `close` while the `Receiver`'s buffer
is not empty, the `Receiver` will still yield the remaining items in the buffer until empty.

## Examples
### Single Sender, Single Receiver
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