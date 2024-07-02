# New To Dart
***
Welcome to Dart!

Dart is a great language choice for fast cross platform development and scripting.
You'll find that rust_core is great start to learn Dart's semantics as you will feel like you are writing native rust.
rust_core will introduce you to a few new types you may find useful as a Dart developer:

| Rust Type         | Dart Equivalent | rust_core | Description                                             |
|-------------------|-----------------|----------------------|---------------------------------------------------------|
| `[T; N]`          | `const [...]`/`List<T>(growable: false)` | `Arr<T>`            | Fixed size array or list                                   |
| `Iterator<T>`     | `Iterable<T>`   |  `RIterator<T>`                  | Composable iteration
| `Option<T>`       | `T?`            | `Option<T>`                    | A type that may hold a value or none                   |
| `Result<T, E>`    |  - | `Result<T, E>`  | Type used for returning and propagating errors|                         |
| `[T]`             | - | `Slice<T>`                    | View into an array or list                                 |
| `Cell<T>`         | - | `Cell<T>`                    | Value wrapper, useful for primitives                                  |
| `channel<T>`      | - | `channel<T>` | Communication between produces and consumers
| `Mutex<T>`      | - | `Mutex` | Exclusion primitive useful for protecting critical sections
| `RwLock<T>`      | - | `RwLock` |  Exclusion primitive allowing multiple read operations and exclusive write operations
| `Path`            | - | `Path`*  | Type for file system path manipulation
| `Vec<T>`          | `List<T>`       | `Vec<T>`*                    | Dynamic array or list                               |

> *: Implemented through additional packages found [here](../misc/packages_built_on_rust_core.md)

To learn more about the Dart programming language, checkout [dart.dev](https://dart.dev/language)!