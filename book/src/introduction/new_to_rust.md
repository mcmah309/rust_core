# New To Rust
***
Welcome to Rust!

Maybe you have heard of Rust and want to see what all the hype is about, maybe you know a little Rust
and want to improve your Rust while writing Dart, for whatever the reason, rust_core is here to help.
Rust has a solid reputation for writing safe, maintainable, and performant code. 
rust_core brings the same tools and philosophy to Dart!
rust_core is also a great start to learn and improve your Rust semantics/knowledge. You will write Dart and learn Rust along the way.
With rust_core you can expect all the usual types you see in Rust. Here is a quick matrix
comparing Rust, Dart, and Dart with rust_core:

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

To learn more about the Rust programming language, checkout the [Rust Book](https://doc.rust-lang.org/book/ch00-00-introduction.html)!