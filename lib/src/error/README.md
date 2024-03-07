# Error

Error contains abstractions for working with errors (aka exceptions). 

## ErrorKind

`ErrorKind` is used to represent an error. This is usually used as the Error/Failure type of a `Result`. 
It similar in functionality to a Rust enum with "thiserror" crate functionality, yet unfortunately not as expressive
due to Dart language constraints.

### How To Use
To use `ErrorKind`, have an enum implement `ErrorEnum`. Each template {number} will be replaced by the corresponding
value at the index provided to `ErrorKind` if `toString()` is called. Don't worry this will never have a runtime error if you forget to provide a value.
```dart
 enum IoError implements ErrorEnum {
    diskRead("Could not read '{0}' from disk."),
    diskWrite("Could not write '{0}' to '{1}' on disk."),
    unknown;
 
  @override
  final String? template;

  const IoError([this.template]);
}

 void main(){
    // can be any object, here a string is used.
   final diskpath = "/home/user/file";
   final ioError = ErrorKind(IoError.diskRead, [diskpath]);
   // toString() -> "IoError: Could not read '/home/user/file' from disk.
   switch(ioError.type){
     case IoError.diskRead:
        // code here
     case IoError.diskWrite:
        // code here
     case IoError.unkown:
        // code here
   }
 }
```

### Advantage vs A Rust Enum
`ErrorKind` does have some advantages over the Rust enum. It _can_ remain untyped (`ErrorKind<Enum>`) and allow you to compose errors of 
different types if you so desire. Although some may warn against doing so as you lose the explicit error type until you
check.

### Alternatives
An alternative to using `ErrorKind` is hand rolling your own sealed classes. That is totally valid yet more verbose.

You can also use the [anyhow](https://pub.dev/packages/anyhow) package.