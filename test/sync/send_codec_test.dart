@TestOn('vm')

import 'package:rust_core/sync.dart';
import 'package:test/test.dart';

void main() {
  group("Codec", () {
    test("StringCodec", () {
      final codec = const StringCodec();
      expect(codec.decode(codec.encode("Hello")), "Hello");
    });

    test("IntCodec", () {
      final codec = const IntCodec();
      expect(codec.decode(codec.encode(1)), 1);
    });

    test("DoubleCodec", () {
      final codec = const DoubleCodec();
      expect(codec.decode(codec.encode(1.0)), 1.0);
    });

    test("BooleanCodec", () {
      final codec = const BooleanCodec();
      expect(codec.decode(codec.encode(true)), true);
    });

    test("IntListCodec", () {
      final codec = const IntListCodec();
      expect(codec.decode(codec.encode([1, 2, 3])), [1, 2, 3]);
    });

    test("DoubleListCodec", () {
      final codec = const DoubleListCodec();
      expect(codec.decode(codec.encode([1.0, 2.0, 3.0])), [1.0, 2.0, 3.0]);
    });

    test("BooleanListCodec", () {
      final codec = const BooleanListCodec();
      expect(codec.decode(codec.encode([true, false])), [true, false]);
    });
  });
}
