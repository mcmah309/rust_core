// ignore_for_file: prefer_typing_uninitialized_variables
// ignore_for_file: unused_local_variable

import 'package:rust_core/result.dart';
import 'package:test/test.dart';

Result<bool, String> boolOk() => Ok(true);
Result<bool, String> boolErr() => Err("");
Result<int,String> intOk() => Ok(1);
Result<int,String> intErr() => Err("");
Result<double, String> doubleOk() => Ok(2.0);
Result<double, String> doubleErr() => Err("");
Result<String, String> stringOk() => Ok("Success");
Result<String, String> stringErr() => Err("");

void main(){
  group("records to result toResult",()
  {
    test("2 records to result Ok", () {
      final a, b;
      switch ((boolOk(), intOk()).toResult()) {
        case Ok(:final ok):
          (a, b) = ok;
        case Err():
          throw Exception();
      }
      expect(a, true);
      expect(b, 1);
    });

    test("2 records to result Err", () {
      bool hasErr = false;
      final a, b;
      switch ((boolOk(), intErr()).toResult()) {
        case Ok(:final ok):
          (a, b) = ok;
        case Err():
          hasErr = true;
      }
      expect(hasErr, true);
    });

    test("3 records to result Ok", () {
      final a, b, c;
      switch ((boolOk(), intOk(), doubleOk()).toResult()) {
        case Ok(:final ok):
          (a, b, c) = ok;
        case Err():
          throw Exception();
      }
      expect(a, true);
      expect(b, 1);
      expect(c, 2.0);
    });

    test("3 records to result Ok", () {
      bool hasErr = false;
      final a, b, c;
      switch ((boolOk(), intErr(), doubleOk()).toResult()) {
        case Ok(:final ok):
          (a, b, c) = ok;
        case Err():
          hasErr = true;
      }
      expect(hasErr, true);
    });

    test("4 records to result Ok", () {
      final a, b, c, d;
      switch ((boolOk(), intOk(), doubleOk(), stringOk()).toResult()) {
        case Ok(:final ok):
          (a, b, c, d) = ok;
        case Err():
          throw Exception();
      }
      expect(a, true);
      expect(b, 1);
      expect(c, 2.0);
      expect(d, "Success");
    });

    test("4 records to result Err", () {
      bool hasErr = false;
      final a, b, c, d;
      switch ((boolOk(), intOk(), doubleErr(), stringOk()).toResult()) {
        case Ok(:final ok):
          (a, b, c, d) = ok;
        case Err():
          hasErr = true;
      }
      expect(hasErr, true);
    });

    // Case 5: 5 records to Result
    test("5 records to result Ok", () {
      final a, b, c, d, e;
      switch ((boolOk(), intOk(), doubleOk(), stringOk(), intOk()).toResult()) {
        case Ok(:final ok):
          (a, b, c, d, e) = ok;
        case Err():
          throw Exception();
      }
      expect(a, true);
      expect(b, 1);
      expect(c, 2.0);
      expect(d, "Success");
      expect(e, 1);
    });

    test("5 records to result Err", () {
      bool hasErr = false;
      final a, b, c, d, e;
      switch ((boolOk(), intOk(), doubleOk(), stringErr(), intOk()).toResult()) {
        case Ok(:final ok):
          (a, b, c, d, e) = ok;
        case Err():
          hasErr = true;
      }
      expect(hasErr, true);
    });
  });

  //************************************************************************//

  group("records to result toResultEager",()
  {
    test("2 records to result Ok", () {
      final a, b;
      switch ((boolOk(), intOk()).toResultEager()) {
        case Ok(:final ok):
          (a, b) = ok;
        case Err():
          throw Exception();
      }
      expect(a, true);
      expect(b, 1);
    });

    test("2 records to result Err", () {
      bool hasErr = false;
      final a, b;
      switch ((boolOk(), intErr()).toResultEager()) {
        case Ok(:final ok):
          (a, b) = ok;
        case Err():
          hasErr = true;
      }
      expect(hasErr, true);
    });

    test("3 records to result Ok", () {
      final a, b, c;
      switch ((boolOk(), intOk(), doubleOk()).toResultEager()) {
        case Ok(:final ok):
          (a, b, c) = ok;
        case Err():
          throw Exception();
      }
      expect(a, true);
      expect(b, 1);
      expect(c, 2.0);
    });

    test("3 records to result Ok", () {
      bool hasErr = false;
      final a, b, c;
      switch ((boolOk(), intErr(), doubleOk()).toResultEager()) {
        case Ok(:final ok):
          (a, b, c) = ok;
        case Err():
          hasErr = true;
      }
      expect(hasErr, true);
    });

    test("4 records to result Ok", () {
      final a, b, c, d;
      switch ((boolOk(), intOk(), doubleOk(), stringOk()).toResultEager()) {
        case Ok(:final ok):
          (a, b, c, d) = ok;
        case Err():
          throw Exception();
      }
      expect(a, true);
      expect(b, 1);
      expect(c, 2.0);
      expect(d, "Success");
    });

    test("4 records to result Err", () {
      bool hasErr = false;
      final a, b, c, d;
      switch ((boolOk(), intOk(), doubleErr(), stringOk()).toResultEager()) {
        case Ok(:final ok):
          (a, b, c, d) = ok;
        case Err():
          hasErr = true;
      }
      expect(hasErr, true);
    });

    // Case 5: 5 records to Result
    test("5 records to result Ok", () {
      final a, b, c, d, e;
      switch ((boolOk(), intOk(), doubleOk(), stringOk(), intOk()).toResultEager()) {
        case Ok(:final ok):
          (a, b, c, d, e) = ok;
        case Err():
          throw Exception();
      }
      expect(a, true);
      expect(b, 1);
      expect(c, 2.0);
      expect(d, "Success");
      expect(e, 1);
    });

    test("5 records to result Err", () {
      bool hasErr = false;
      final a, b, c, d, e;
      switch ((boolOk(), intOk(), doubleOk(), stringErr(), intOk()).toResultEager()) {
        case Ok(:final ok):
          (a, b, c, d, e) = ok;
        case Err():
          hasErr = true;
      }
      expect(hasErr, true);
    });
  });
}