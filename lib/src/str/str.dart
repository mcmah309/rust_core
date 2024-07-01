import 'package:rust_core/iter.dart';

extension StringExtension on String {
  /// An Iterator of code units of this [String] represented as individual [String]s
  @pragma("vm:prefer-inline")
  RIterator<String> chars() {
    return RIterator.fromIterable(codeUnits.map((e) => String.fromCharCode(e)));
  }

  @pragma("vm:prefer-inline")
  bool eqIgnoreCase(String other) {
    return toLowerCase() == other.toLowerCase();
  }
}
