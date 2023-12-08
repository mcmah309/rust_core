# rust_core

[![Pub Version](https://img.shields.io/pub/v/rust_core.svg)](https://pub.dev/packages/rust_core)
[![Dart Package Docs](https://img.shields.io/badge/documentation-pub.dev-blue.svg)](https://pub.dev/documentation/rust_core/latest/)
[![License: MIT](https://img.shields.io/badge/license-MIT-purple.svg)](https://opensource.org/licenses/MIT)
[![Build Status](https://github.com/mcmah309/rust_core/actions/workflows/dart.yml/badge.svg)](https://github.com/mcmah309/rust_core/actions)

Implementation of Rust's core library in a Dart friendly way.

rust_core allows for idiomatic programming in dart with predictable control flow. We carefully adapt Rust's 
functionalities to Dart's paradigms, ensuring a smooth, 
language-compatible integration. E.g. `Option` and Nullable types are equally supported throughout. If a method or 
extension exists for `Option<T>` it exists for `T?`. Thus, rust_core seamlessly integrates the essence of Rust's 
core library into Dart.

## Highlights
### Libraries

| [Result] | [Option] | [Cell] | [Panic] | [Typedefs]

🔥 **Dozens of Extensions, 100's of methods:** Crafted to address specific scenarios in Dart.

🧪 **Robust Testing:** Over 300 meaningful tests, we aim for reliability and performance in every feature.

🚀 **Beyond Rust Core:** While rust_core faithfully implements the Rust Core library in Dart, our vision extends further.
We aim to be an indispensable tool for every Dart project and a foundational library for the broader ecosystem.

### Official Packages Based Off rust_core
| Library | Description |
| ------- | ----------- |
| [anyhow] | Idiomatic error handling capabilities to make your code safer, more maintainable, and errors easier to debug. |
| [tapper] | Extension methods on all types that allow transparent, temporary, inspection/mutation (tapping), transformation (piping), or type conversion. |


[Cell]: https://github.com/mcmah309/rust_core/tree/master/lib/src/cell
[Option]: https://github.com/mcmah309/rust_core/tree/master/lib/src/option
[Panic]: https://github.com/mcmah309/rust_core/tree/master/lib/src/panic
[Result]: https://github.com/mcmah309/rust_core/tree/master/lib/src/result
[Typedefs]: https://github.com/mcmah309/rust_core/tree/master/lib/src/typedefs


[anyhow]: https://pub.dev/packages/anyhow
[tapper]: https://pub.dev/packages/tapper