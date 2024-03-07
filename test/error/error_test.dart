import 'package:rust_core/error.dart';
import 'package:test/test.dart';

enum IoError implements ErrorEnum {
  oneTemplateVariable("Could not read '{0}' from disk."),
  twoTemplateVariables("Could not write '{0}' to '{1}' on disk."),
  oneTemplateVariableTwoTimes("Make sure that {0} is correct {0}"),
  noTemplateVariable("An unknown error occurred."),
  empty,
  twoTemplateVariablesOutOfOrder("Could not write '{1}' to '{0}' on disk.");

  @override
  final String? template;

  const IoError([this.template]);
}

void main() {
  group("oneTemplateVariable", () {
    test("one template variable with value", () {
      final diskpath = "/home/user/file";
      final x = ErrorKind(IoError.oneTemplateVariable, [diskpath]);
      switch (x.type) {
        case IoError.oneTemplateVariable:
        case IoError.twoTemplateVariables:
        case IoError.oneTemplateVariableTwoTimes:
        case IoError.noTemplateVariable:
        case IoError.empty:
        case IoError.twoTemplateVariablesOutOfOrder:
      }
      expect(x.toString(), "IoError: Could not read '/home/user/file' from disk.");
    });

    test("one template variable without value", () {
      final x = ErrorKind(IoError.oneTemplateVariable, []);
      expect(x.toString(), "IoError: Could not read '{0}' from disk.");
    });

    test("one template variable with too many values value", () {
      final diskpath = "/home/user/file";
      final x = ErrorKind(IoError.oneTemplateVariable, [diskpath]);
      expect(x.toString(), "IoError: Could not read '/home/user/file' from disk.");
    });

    test("no value", () {
      final x = ErrorKind(IoError.oneTemplateVariable);
      expect(x.toString(), "IoError: Could not read '{0}' from disk.");
    });
  });

  group("twoTemplateVariables", () {
    test("two template variable with value", () {
      final value = "bing bong";
      final diskpath = "/home/user/file";
      final x = ErrorKind(IoError.twoTemplateVariables, [value, diskpath]);
      expect(x.toString(), "IoError: Could not write 'bing bong' to '/home/user/file' on disk.");
    });

    test("two template variable without value", () {
      final x = ErrorKind(IoError.twoTemplateVariables, []);
      expect(x.toString(), "IoError: Could not write '{0}' to '{1}' on disk.");
    });

    test("two template variable with one value", () {
      final value = "bing bong";
      final x = ErrorKind(IoError.twoTemplateVariables, [value]);
      expect(x.toString(), "IoError: Could not write 'bing bong' to '{1}' on disk.");
    });

    test("two template variable with too many values value", () {
      final value = "bing bong";
      final diskpath = "/home/user/file";
      final extraValue = "too much";
      final x = ErrorKind(IoError.twoTemplateVariables, [value, diskpath, extraValue]);
      expect(x.toString(), "IoError: Could not write 'bing bong' to '/home/user/file' on disk.");
    });

    test("no value", () {
      final x = ErrorKind(IoError.twoTemplateVariables);
      expect(x.toString(), "IoError: Could not write '{0}' to '{1}' on disk.");
    });
  });

  group("oneTemplateVariableTwoTimes", () {
    test("one value", () {
      final value = "bing bong";
      final x = ErrorKind(IoError.oneTemplateVariableTwoTimes, [value]);
      expect(x.toString(), "IoError: Make sure that bing bong is correct bing bong");
    });

    test("two values", () {
      final value = "bing bong";
      final diskpath = "/home/user/file";
      final x = ErrorKind(IoError.oneTemplateVariableTwoTimes, [value, diskpath]);
      expect(x.toString(), "IoError: Make sure that bing bong is correct bing bong");
    });

    test("no values", () {
      final x = ErrorKind(IoError.oneTemplateVariableTwoTimes, []);
      expect(x.toString(), "IoError: Make sure that {0} is correct {0}");
    });

    test("too many values", () {
      final value = "bing bong";
      final diskpath = "/home/user/file";
      final extraValue = "too much";
      final x = ErrorKind(IoError.oneTemplateVariableTwoTimes, [value, diskpath, extraValue]);
      expect(x.toString(), "IoError: Make sure that bing bong is correct bing bong");
    });

    test("no value", () {
      final x = ErrorKind(IoError.oneTemplateVariableTwoTimes);
      expect(x.toString(), "IoError: Make sure that {0} is correct {0}");
    });
  });

  group("noTemplateVariable", () {
    test("one value", () {
      final value = "bing bong";
      final x = ErrorKind(IoError.noTemplateVariable, [value]);
      expect(x.toString(), "IoError: An unknown error occurred.");
    });

    test("two values", () {
      final value = "bing bong";
      final diskpath = "/home/user/file";
      final x = ErrorKind(IoError.noTemplateVariable, [value, diskpath]);
      expect(x.toString(), "IoError: An unknown error occurred.");
    });

    test("no values", () {
      final x = ErrorKind(IoError.noTemplateVariable, []);
      expect(x.toString(), "IoError: An unknown error occurred.");
    });
  });

  group("noTemplateVariable", () {
    test("one value", () {
      final value = "bing bong";
      final x = ErrorKind(IoError.noTemplateVariable, [value]);
      expect(x.toString(), "IoError: An unknown error occurred.");
    });

    test("two values", () {
      final value = "bing bong";
      final diskpath = "/home/user/file";
      final x = ErrorKind(IoError.noTemplateVariable, [value, diskpath]);
      expect(x.toString(), "IoError: An unknown error occurred.");
    });

    test("no values", () {
      final x = ErrorKind(IoError.noTemplateVariable, []);
      expect(x.toString(), "IoError: An unknown error occurred.");
    });
  });

  group("empty", () {
    test("one value", () {
      final value = "bing bong";
      final x = ErrorKind(IoError.empty, [value]);
      expect(x.toString(), "IoError");
    });

    test("two values", () {
      final value = "bing bong";
      final diskpath = "/home/user/file";
      final x = ErrorKind(IoError.empty, [value, diskpath]);
      expect(x.toString(), "IoError");
    });

    test("no values", () {
      final x = ErrorKind(IoError.empty, []);
      expect(x.toString(), "IoError");
    });
  });

  group("twoTemplateVariables", () {
    test("two template variable with value", () {
      final value = "bing bong";
      final diskpath = "/home/user/file";
      final x = ErrorKind(IoError.twoTemplateVariablesOutOfOrder, [value, diskpath]);
      expect(x.toString(), "IoError: Could not write '/home/user/file' to 'bing bong' on disk.");
    });

    test("two template variable without value", () {
      final x = ErrorKind(IoError.twoTemplateVariablesOutOfOrder, []);
      expect(x.toString(), "IoError: Could not write '{1}' to '{0}' on disk.");
    });

    test("two template variable with one value", () {
      final value = "bing bong";
      final x = ErrorKind(IoError.twoTemplateVariablesOutOfOrder, [value]);
      expect(x.toString(), "IoError: Could not write '{1}' to 'bing bong' on disk.");
    });

    test("two template variable with too many values value", () {
      final value = "bing bong";
      final diskpath = "/home/user/file";
      final extraValue = "too much";
      final x = ErrorKind(IoError.twoTemplateVariablesOutOfOrder, [value, diskpath, extraValue]);
      expect(x.toString(), "IoError: Could not write '/home/user/file' to 'bing bong' on disk.");
    });

    test("no value", () {
      final x = ErrorKind(IoError.twoTemplateVariablesOutOfOrder);
      expect(x.toString(), "IoError: Could not write '{1}' to '{0}' on disk.");
    });
  });
}
