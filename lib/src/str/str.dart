import 'package:rust_core/iter.dart';

extension StringExtension on String {

  /// An Iterator of code units of this [String] represented as individual [String]s
  RIterator<String> chars() {
    return RIterator.fromIterable(codeUnits.map((e) => String.fromCharCode(e)));
  }
}
