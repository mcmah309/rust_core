import 'dart:async';
// import 'dart:io';

import 'package:rust_core/sync.dart';
import 'package:test/test.dart';

//************************************************************************//
// For debug output
//
// Uncomment the "stdout.write" line in the [debugWrite] method to enable
// debug output.

int numReadAcquired = 0;
int numReadReleased = 0;

enum State { waitingToAcquire, acquired, released }

const stateSymbol = <State, String>{
  State.waitingToAcquire: '?',
  State.acquired: '+',
  State.released: '-'
};

var _outputCount = 0; // to manage line breaks

void debugOutput(String id, State state) {
  debugWrite('$id${stateSymbol[state]} ');

  _outputCount++;
  if (_outputCount % 10 == 0) {
    debugWrite('\n');
  }
}

void debugWrite(String str) {
  // Uncomment to show what is happening
  // stdout.write(str);
}

//************************************************************************//

Future<void> mySleep([int ms = 1000]) async {
  await Future<void>.delayed(Duration(milliseconds: ms));
}

Future<void> sharedLoop1(RwLock mutex, String symbol) async {
  while (true) {
    debugOutput(symbol, State.waitingToAcquire);

    await mutex.withReadLock(() async {
      numReadAcquired++;
      debugOutput(symbol, State.acquired);

      await mySleep(100);
    });
    numReadReleased++;

    debugOutput(symbol, State.released);
  }
}

void main() {
  group('exclusive lock tests', () {
    test('test1', () async {
      const numReadLoops = 5;

      final mutex = RwLock();

      assert(numReadLoops < 26, 'too many read loops for lowercase letters');
      debugWrite('Number of read loops: $numReadLoops\n');

      for (var x = 0; x < numReadLoops; x++) {
        final symbol = String.fromCharCode('a'.codeUnitAt(0) + x);
        unawaited(sharedLoop1(mutex, symbol));
        await mySleep(10);
      }

      await mySleep(1000);

      debugWrite('\nAbout to acquireWrite'
          ' (reads: acquired=$numReadAcquired released=$numReadReleased'
          ' outstanding=${numReadAcquired - numReadReleased})\n');
      _outputCount = 0; // reset line break

      const writeSymbol = 'W';

      debugOutput(writeSymbol, State.waitingToAcquire);
      await mutex.write();
      debugOutput(writeSymbol, State.acquired);
      mutex.release();
      debugOutput(writeSymbol, State.released);

      debugWrite('\nWrite mutex released\n');
      _outputCount = 0; // reset line break

      expect('a', 'a');
    });
  });
}