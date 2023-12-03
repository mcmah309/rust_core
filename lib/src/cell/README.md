# Cell

Cell is library of useful wrappers of values (cells). Most notable `OnceCell` and `LazyCell`.

`OnceCell` - A cell which can be written to only once. Various implementations are provided for nullable, 
non-nullable, and const.

`LazyCell` - A value which is initialized on the first access. Various implementations are provided for nullable,
non-nullable, and const.

That is correct, you can use these Cells with `const`. That opens up a lot of possibilities. Most notable being 
default types for classes constructed at build time, like with the [freezed] package.


🚧 **Page and Classes Under Construction** 🚧

✅ Finished: `OnceCell` and `LazyCell`

[freezed]:https://pub.dev/packages/freezed