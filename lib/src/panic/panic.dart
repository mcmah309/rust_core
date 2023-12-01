/// As with [Error], [Panic] represents a state that should never happen and thus should never be caught.
class Panic extends Error {
  /// A value that is related to the panic
  final Object? onValue;

  /// The situation that led to the panic
  final String? reason;

  Panic({this.onValue, this.reason});

  @override
  String toString() {
    final panicAsString = StringBuffer("Panic:");
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
