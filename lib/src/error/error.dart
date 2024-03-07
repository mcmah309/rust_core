/// An error enum with an optional template. e.g. "Could not write {0} to {1} on disk".
/// To be implemented by an [Enum] and used by [ErrorKind].
abstract class ErrorEnum implements Enum {
  final String? template;

  ErrorEnum([this.template]);
}

/// An abstraction to write concise errors. e.g.
/// ```dart
/// enum IoError implements ErrorEnum {
///    diskRead("Could not read '{0}' from disk."),
///    diskWrite("Could not write '{0}' to '{1}' on disk."),
///    unknown;
///
///  @override
///  final String? template;
///
///  const IoError([this.template]);
///}
///
/// void main(){
///   final diskpath = "/home/user/file";
///   final ioError = ErrorKind(IoError.diskRead, [diskpath]);
///   // toString() -> "IoError: Could not read '/home/user/file' from disk.
///   switch(ioError.type){
///     case IoError.diskRead:
///     ...
///   }
/// }
/// ```
class ErrorKind<E extends ErrorEnum> {
  static final _innerNumberCapture = RegExp(r'{(\d+)}');

  final E type;
  final List<Object>? values;

  ErrorKind(this.type, [this.values])
  // : assert(() {
  //     final format = type.template;
  //     if(format != null){
  //       Iterable<RegExpMatch> matches = innerNumberCapture.allMatches(format);

  //       for (var match in matches) {
  //         int index = int.parse(match.group(1)!);
  //         if(values == null){
  //           throw "An $ErrorKind class with type ${type.runtimeType}, expects a value at index '$index' but values was null.";
  //         }
  //         if(values.length - 1 > index){
  //           throw "An $ErrorKind class with type ${type.runtimeType}, expects a value at index '$index' but values only ${values.length} values were provided.";
  //         }
  //       }
  //     }
  //     return true;
  //   }())
  ;

  @override
  String toString() {
    final template = type.template;
    if (values == null) {
      if (template == null) {
        return "${type.runtimeType}";
      } else {
        return "${type.runtimeType}: $template";
      }
    }
    if (template == null) {
      return "${type.runtimeType}";
    }
    final replacedTemplate = template.replaceAllMapped(_innerNumberCapture, (Match match) {
      int index = int.parse(match.group(1)!);
      if (index < values!.length) {
        return values![index].toString();
      } else {
        // If index is out of bounds, keep the original placeholder
        return match.group(0)!;
      }
    }).trim();
    if (replacedTemplate.isEmpty) {
      return "${type.runtimeType}";
    } else {
      return "${type.runtimeType}: $replacedTemplate";
    }
  }

  @override
  bool operator ==(Object other) {
    return other is ErrorKind && other.type == type;
  }

  @override
  int get hashCode => type.hashCode;
}
