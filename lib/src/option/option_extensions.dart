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