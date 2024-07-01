/// The error type for errors that can never happen
typedef Infallible = Never;

/// The identity function.
/// While it might seem strange to have a function that just returns back the input, there are some interesting uses.
/// ```dart
/// var function = conditional ? identity : manipulate;
/// ```
@pragma("vm:prefer-inline")
T identity<T>(T x) => x;