# Option
***
Option represents the union of two types - `Some<T>` and `None`. An `Option<T>` is an extension type of `T?`. Therefore, `Option`
has zero runtime cost.

rust_core support nullable and `Option` implementations of classes and methods for ergonomic convenience where possible, but you
can easily switch between the two with no runtime cost.

```dart
Option<int> option = None;

int? nullable = option.v;
option = Option.from(nullable);

nullable = option as int?; // or
option = nullable as Option<int>; // or
```

### Usage
The `Option` type and features work very similar to [Result](../result/result.md). We are able to chain operations in a safe way without
needing a bunch of `if` statements to check if a value is null.

```dart
Option<int> intOptionFunc() => None;
double halfVal(int val) => val/2;
Option<double> val = intOptionFunc()
    .map(halfVal);
expect(val.unwrapOr(2), 2);
```
See the [docs](https://pub.dev/documentation/rust_core/latest/option/option-library.html) for all methods and extensions.

You can also use Option in pattern matching
```dart
switch(Some(2)){
  case Some(:final v):
    // do something
  default:
    // do something
}
```
or
```dart
final x = switch(Some(2)){
  Some(:final v) => "some"
  _ => "none"
}
```

### Early Return Key Notation
Option also supports "Early Return Key Notation" (ERKN), which is a derivative of "Do Notation". It allows a 
function to return early if the value is `None`, and otherwise safely access the inner value directly without needing to unwrap or type check.
```dart
Option<int> intNone() => None;
Option<double> earlyReturn(int val) => Option(($) { // Early Return Key
  // Returns here
  double x = intNone()[$].toDouble();
  return Some(val + x);
});
expect(earlyReturn(2), None);
```
This is a powerful concept and make you code much more concise without losing any safety.

For async, use `Option.async` e.g.
```dart
FutureOption<double> earlyReturn() => Option.async(($) async {
  ...
});
```

### To Option or Not To Option
If Dart already supports nullable types, why use an option type? Nullable types may required an
uncomfortable level of null checking and nesting. Even so, one may also still need to write a null
assertion `!` for some edge cases where the compiler is not smart enough.
The `Option` type provides an alternative solution with methods and early return.

Methods:
```dart
final profile;
final preferences;

switch (fetchUserProfile()
    .map((e) => "${e.name} - profile")
    .andThen((e) => Some(e).zip(fetchUserPreferences()))) {
  case Some(:final v):
    (profile, preferences) = v;
  default:
    return;
}

print('Profile: $profile, Preferences: $preferences');

```
Early Return Notation:
```dart
final (profile, preferences) = fetchUserProfile()
      .map((e) => "${e.name} - profile")
      .andThen((e) => Some(e).zip(fetchUserPreferences()))[$];

print('Profile: $profile, Preferences: $preferences');
```
Traditional Null-Based Approach:
```dart
final profile = fetchUserProfile();
if (profile == null) {
  return;
} else {
  profile = profile.name + " - profile";
}

final preferences = fetchUserPreferences();
if (preferences == null) {
  return;
}

print('Profile: $profile, Preferences: $preferences');
```

#### Drawbacks
Currently in Dart, one cannot rebind variables and `Option` does not support type promotion like nullable types. 
This makes using `Option` less ergonomic in some scenarios.
```dart
Option<int> xOpt = ...;
int x;
switch(xOpt) {
  Some(:final v):
    x = v;
  default:
    return;
}
// use `int` x
```
vs
```dart
int? x = ...;
if(x == null){
  return;
}
// use `int` x
```

#### Conclusion
If you can't decide between the two, it is recommended to use the `Option` type as the return type, since it allows 
early return, chaining operations, and easy conversion to a nullable type with `.v`. But the choice is up to the developer.
You can easily use this package and never use `Option`.