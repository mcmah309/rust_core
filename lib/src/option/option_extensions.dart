import 'package:rust_core/option.dart';


extension ToOption1<T extends Object> on T? {

  /// Returns [None] if this is null and Some(this) if this not null.
  Option<T> toOption(){
    if(this == null){
      return const None();
    }
    return Some(this!);
  }
}

extension ToOption2<T extends Object> on T {

  /// Returns [None] if this is null and Some(this) if this not null.
  Option<T> toOption(){
    return Some(this);
  }
}

extension OptionOptionExtension<T extends Object> on Option<Option<T>> {
  /// Converts from Option<Option<T>> to Option<T>.
  Option<T> flatten(){
    if(isSome()){
      return unwrap();
    }
    return const None();
  }
}

extension OptionRecord2Extension<T extends Object, U extends Object> on Option<(T,U)> {
  /// Unzips an option containing a tuple of two options.
  /// If self is Some((a, b)) this method returns (Some(a), Some(b)). Otherwise, (None, None) is returned.
  (Option<T>, Option<U>) unzip(){
    if(isSome()){
      final (one, two) = unwrap();
      return (Some(one), Some(two));
    }
    return (const None(), const None());
  }
}