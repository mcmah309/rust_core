/// As with [Error], [Panic] represents a state that should never happen and thus is not expected to be catch.
/// This is closely tied to the `unwrap` method of both [Option] and [Result] types.
class Panic extends Error {
  final String? msg;

  Panic([this.msg]);

  @override
  String toString() {
    if (msg == null) {
      return "Panic: Undefined state.";
    }
    return "Panic: $msg";
  }
}

/// Shorthand for
/// ```dart
/// throw Panic(...)
/// ```
Never panic([String? msg]) {
  throw Panic(msg);
}
