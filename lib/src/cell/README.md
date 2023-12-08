# Cell

Cell is library of useful wrappers of values (cells).

`Cell` - A wrapper around a value. useful to "mimic" references. Extensions exist for primitives. e.g. `Cell<int>` 
can be used similar to a normal `int`.

`OnceCell` - A cell which can be written to only once.

`LazyCell` - A value which is initialized on the first access.

Most Cells have a `const`, `nullable` and `non-nullable` implementation. That opens up a lot of possibilities. e.g. 
with the `const` types, you can wrap non-const types. Allowing them to be used for something like `@Default(...)`  
with the 
[freezed] package.


🚧 **Page and Classes Under Construction** 🚧

[freezed]:https://pub.dev/packages/freezed