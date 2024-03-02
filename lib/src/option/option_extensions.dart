part of 'option.dart';

extension NullableTExtension<T extends Object> on T? {
  /// Returns [None] if this is null and Some(this) if this not null.
  Option<T> toOption() {
    return Option._(this);
  }
}

extension OptionOptionExtension<T> on Option<Option<T>> {
  /// Converts from Option<Option<T>> to Option<T>.
  Option<T> flatten() {
    if (isSome()) {
      return unwrap();
    }
    return const None();
  }
}

extension OptionRecord2Extension<T, U>
    on Option<(T, U)> {
  /// Unzips an option containing a tuple of two options.
  /// If self is Some((a, b)) this method returns (Some(a), Some(b)). Otherwise, (None, None) is returned.
  (Option<T>, Option<U>) unzip() {
    if (isSome()) {
      final (one, two) = unwrap();
      return (Some(one), Some(two));
    }
    return (const None(), const None());
  }
}

//************************************************************************//

extension NullFunctionToOptionFunction1<T> on T? Function() {
  /// Converts a function that returns a nullable value to a function that returns an option.
  Option<T> Function() toOptionFunction() {
    return () => Option._(this());
  }
}

extension NullFunctionToOptionFunction2<T,A> on T? Function(A) {
  /// Converts a function that returns a nullable value to a function that returns an option.
  Option<T> Function(A) toOptionFunction() {
    return (a) => Option._(this(a));
  }
}

extension NullFunctionToOptionFunction3<T,A, B> on T? Function(A, B) {
  /// Converts a function that returns a nullable value to a function that returns an option.
  Option<T> Function(A,B) toOptionFunction() {
    return (a,b) => Option._(this(a,b));
  }
}

extension NullFunctionToOptionFunction4<T,A, B, C> on T? Function(A, B, C) {
  /// Converts a function that returns a nullable value to a function that returns an option.
  Option<T> Function(A,B,C) toOptionFunction() {
    return (a,b,c) => Option._(this(a,b,c));
  }
}

extension NullFunctionToOptionFunction5<T,A, B, C, D> on T? Function(A, B, C, D) {
  /// Converts a function that returns a nullable value to a function that returns an option.
  Option<T> Function(A,B,C,D) toOptionFunction() {
    return (a,b,c,d) => Option._(this(a,b,c,d));
  }
}

extension NullFunctionToOptionFunction6<T,A, B, C, D, E> on T? Function(A, B, C, D, E) {
  /// Converts a function that returns a nullable value to a function that returns an option.
  Option<T> Function(A,B,C,D,E) toOptionFunction() {
    return (a,b,c,d,e) => Option._(this(a,b,c,d,e));
  }
}

extension NullFunctionToOptionFunction7<T,A, B, C, D, E, F> on T? Function(A, B, C, D, E, F) {
  /// Converts a function that returns a nullable value to a function that returns an option.
  Option<T> Function(A,B,C,D,E,F) toOptionFunction() {
    return (a,b,c,d,e,f) => Option._(this(a,b,c,d,e,f));
  }
}

extension NullFunctionToOptionFunction8<T,A, B, C, D, E, F, G> on T? Function(A, B, C, D, E, F, G) {
  /// Converts a function that returns a nullable value to a function that returns an option.
  Option<T> Function(A,B,C,D,E,F,G) toOptionFunction() {
    return (a,b,c,d,e,f,g) => Option._(this(a,b,c,d,e,f,g));
  }
}

//************************************************************************//

extension OptionFunctionToNullFunction1<T> on Option<T> Function() {
  /// Converts a function that returns an option to a function that returns a nullable value.
  T? Function() toNullFunction() {
    return () => this().v;
  }
}

extension OptionFunctionToNullFunction2<T,A> on Option<T> Function(A) {
  /// Converts a function that returns an option to a function that returns a nullable value.
  T? Function(A) toNullFunction() {
    return (a) => this(a).v;
  }
}

extension OptionFunctionToNullFunction3<T,A, B> on Option<T> Function(A, B) {
  /// Converts a function that returns an option to a function that returns a nullable value.
  T? Function(A,B) toNullFunction() {
    return (a,b) => this(a,b).v;
  }
}

extension OptionFunctionToNullFunction4<T,A, B, C> on Option<T> Function(A, B, C) {
  /// Converts a function that returns an option to a function that returns a nullable value.
  T? Function(A,B,C) toNullFunction() {
    return (a,b,c) => this(a,b,c).v;
  }
}

extension OptionFunctionToNullFunction5<T,A, B, C, D> on Option<T> Function(A, B, C, D) {
  /// Converts a function that returns an option to a function that returns a nullable value.
  T? Function(A,B,C,D) toNullFunction() {
    return (a,b,c,d) => this(a,b,c,d).v;
  }
}

extension OptionFunctionToNullFunction6<T,A, B, C, D, E> on Option<T> Function(A, B, C, D, E) {
  /// Converts a function that returns an option to a function that returns a nullable value.
  T? Function(A,B,C,D,E) toNullFunction() {
    return (a,b,c,d,e) => this(a,b,c,d,e).v;
  }
}

extension OptionFunctionToNullFunction7<T,A, B, C, D, E, F> on Option<T> Function(A, B, C, D, E, F) {
  /// Converts a function that returns an option to a function that returns a nullable value.
  T? Function(A,B,C,D,E,F) toNullFunction() {
    return (a,b,c,d,e,f) => this(a,b,c,d,e,f).v;
  }
}

extension OptionFunctionToNullFunction8<T,A, B, C, D, E, F, G> on Option<T> Function(A, B, C, D, E, F, G) {
  /// Converts a function that returns an option to a function that returns a nullable value.
  T? Function(A,B,C,D,E,F,G) toNullFunction() {
    return (a,b,c,d,e,f,g) => this(a,b,c,d,e,f,g).v;
  }
}