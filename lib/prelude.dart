/// Rust comes with a variety of things in its standard library.
/// However, if you had to manually import every single thing that you used,
/// it would be very verbose. But importing a lot of things that a program never uses isn’t good either.
/// A balance needs to be struck.
/// The prelude is the list of things that Rust automatically imports into every Rust program. 
/// It’s kept as small as possible, and is focused on things, particularly traits, 
/// which are used in almost every single Rust program.
library prelude;

export "array.dart";
export "cell.dart";
export "iter.dart";
export "option.dart";
export "panic.dart";
export "result.dart";
export "slice.dart";
export "typedefs.dart";