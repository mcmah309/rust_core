// ignore_for_file: prefer_typing_uninitialized_variables
// ignore_for_file: unused_local_variable

import 'package:rust_core/option.dart';
import 'package:test/test.dart';

Option<bool> boolSome() => Some(true);
Option<bool> boolNone() => None;
Option<int> intSome() => Some(1);
Option<int> intNone() => None;
Option<double> doubleSome() => Some(2.0);
Option<double> doubleNone() => None;
Option<String> stringSome() => Some("Success");
Option<String> stringNone() => None;

void main() {
  group("records to option toOption", () {
    test("2 records to option Some", () {
      final a, b;
      switch ((boolSome(), intSome()).toOption()) {
        case Some(:final v):
          (a, b) = v;
        default:
          throw Exception();
      }
      expect(a, true);
      expect(b, 1);
    });

    test("2 records to option None", () {
      bool hasNone = false;
      final a, b;
      switch ((boolSome(), intNone()).toOption()) {
        case Some(:final v):
          (a, b) = v;
        default:
          hasNone = true;
      }
      expect(hasNone, true);
    });

    test("3 records to option Some", () {
      final a, b, c;
      switch ((boolSome(), intSome(), doubleSome()).toOption()) {
        case Some(:final v):
          (a, b, c) = v;
        default:
          throw Exception();
      }
      expect(a, true);
      expect(b, 1);
      expect(c, 2.0);
    });

    test("3 records to option None", () {
      bool hasNone = false;
      final a, b, c;
      switch ((boolSome(), intNone(), doubleSome()).toOption()) {
        case Some(:final v):
          (a, b, c) = v;
        default:
          hasNone = true;
      }
      expect(hasNone, true);
    });

    test("4 records to option Some", () {
      final a, b, c, d;
      switch ((boolSome(), intSome(), doubleSome(), stringSome()).toOption()) {
        case Some(:final v):
          (a, b, c, d) = v;
        default:
          throw Exception();
      }
      expect(a, true);
      expect(b, 1);
      expect(c, 2.0);
      expect(d, "Success");
    });

    test("4 records to option None", () {
      bool hasNone = false;
      final a, b, c, d;
      switch ((boolSome(), intSome(), doubleNone(), stringSome()).toOption()) {
        case Some(:final v):
          (a, b, c, d) = v;
        default:
          hasNone = true;
      }
      expect(hasNone, true);
    });

    test("5 records to option Some", () {
      final a, b, c, d, e;
      switch ((boolSome(), intSome(), doubleSome(), stringSome(), intSome())
          .toOption()) {
        case Some(:final v):
          (a, b, c, d, e) = v;
        default:
          throw Exception();
      }
      expect(a, true);
      expect(b, 1);
      expect(c, 2.0);
      expect(d, "Success");
      expect(e, 1);
    });

    test("5 records to option None", () {
      bool hasNone = false;
      final a, b, c, d, e;
      switch ((boolSome(), intSome(), doubleSome(), stringNone(), intSome())
          .toOption()) {
        case Some(:final v):
          (a, b, c, d, e) = v;
        default:
          hasNone = true;
      }
      expect(hasNone, true);
    });
  });

  group("record functions to option", () {
    test("2 record functions to option Some", () {
      final a, b;
      switch ((boolSome, intSome).toOption()) {
        case Some(:final v):
          (a, b) = v;
        default:
          throw Exception();
      }
      expect(a, true);
      expect(b, 1);
    });

    test("2 record functions to option None", () {
      bool hasNone = false;
      final a, b;
      switch ((boolSome, intNone).toOption()) {
        case Some(:final v):
          (a, b) = v;
        default:
          hasNone = true;
      }
      expect(hasNone, true);
    });

    test("3 record functions to option Some", () {
      final a, b, c;
      switch ((boolSome, intSome, doubleSome).toOption()) {
        case Some(:final v):
          (a, b, c) = v;
        default:
          throw Exception();
      }
      expect(a, true);
      expect(b, 1);
      expect(c, 2.0);
    });

    test("3 record functions to option None", () {
      bool hasNone = false;
      final a, b, c;
      switch ((boolSome, intNone, doubleSome).toOption()) {
        case Some(:final v):
          (a, b, c) = v;
        default:
          hasNone = true;
      }
      expect(hasNone, true);
    });

    test("4 record functions to option Some", () {
      final a, b, c, d;
      switch ((boolSome, intSome, doubleSome, stringSome).toOption()) {
        case Some(:final v):
          (a, b, c, d) = v;
        default:
          throw Exception();
      }
      expect(a, true);
      expect(b, 1);
      expect(c, 2.0);
      expect(d, "Success");
    });

    test("4 record functions to option None", () {
      bool hasNone = false;
      final a, b, c, d;
      switch ((boolSome, intSome, doubleNone, stringSome).toOption()) {
        case Some(:final v):
          (a, b, c, d) = v;
        default:
          hasNone = true;
      }
      expect(hasNone, true);
    });

    test("5 record functions to option Some", () {
      final a, b, c, d, e;
      switch ((boolSome, intSome, doubleSome, stringSome, intSome).toOption()) {
        case Some(:final v):
          (a, b, c, d, e) = v;
        default:
          throw Exception();
      }
      expect(a, true);
      expect(b, 1);
      expect(c, 2.0);
      expect(d, "Success");
      expect(e, 1);
    });

    test("5 record functions to option None", () {
      bool hasNone = false;
      final a, b, c, d, e;
      switch ((boolSome, intSome, doubleSome, stringNone, intSome).toOption()) {
        case Some(:final v):
          (a, b, c, d, e) = v;
        default:
          hasNone = true;
      }
      expect(hasNone, true);
    });
  });
}
