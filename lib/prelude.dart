/// rust_core comes with a variety of things in its core library.
/// However, if you had to manually import every single thing that you used,
/// it would be very verbose. But importing a lot of things that a program never uses isn’t good either.
/// A balance needs to be struck.
/// The prelude is the list of things that rust_core should automatically imports into almost all projects. 
/// It’s kept as small as possible, and is focused on things, 
/// which are used in almost every single rust_core program.
library prelude;

export "array.dart";
export "iter.dart";
export "option.dart";
export "panic.dart";
export "result.dart";
export "slice.dart";
export "typedefs.dart";