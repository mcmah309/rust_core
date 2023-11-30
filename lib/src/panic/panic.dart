import 'dart:core' as Core;

/// As with [Error], [Panic] represents a state that should never happen and thus should never be caught.
class Panic extends Core.Error {
  /// A value that is related to the panic
  final Core.Object? onValue;

  /// The situation that led to the panic
  final Core.String? reason;

  Panic({this.onValue, this.reason});

  @Core.override
  Core.String toString() {
    final panicAsString = Core.StringBuffer("Panic:");
    if (reason != null) {
      panicAsString.write(" \"");
      panicAsString.write(reason);
      panicAsString.write("\"");
    }
    if (onValue != null) {
      panicAsString
          .write(" on an ${onValue.runtimeType} with value:\n$onValue");
    }
    if (reason == null && onValue == null) {
      panicAsString.write(" Undefined state");
    }
    return panicAsString.toString();
  }
}
