import 'package:rust_core/panic.dart';

/// Indicates unreachable code.
/// This is useful any time that the compiler can’t determine that some code is unreachable. For example:
///  - Switch arms with guard conditions.
///  - Loops that dynamically terminate.
///  - Iterators that dynamically terminate.
/// [Unreachable] is just a shorthand for [Panic] with a fixed, specific message.
class Unreachable extends Panic {
  Unreachable([String msg = "This code should be unreachable."]): super(msg);
}

/// Shorthand for
/// ```dart
/// throw Unreachable(...)
/// ```
Never unreachable([String msg = "This code should be unreachable."]) {
  throw Unreachable(msg);
}