# rust_core

[![Pub Version](https://img.shields.io/pub/v/rust_core.svg)](https://pub.dev/packages/rust_core)
[![Dart Package Docs](https://img.shields.io/badge/documentation-pub.dev-blue.svg)](https://pub.dev/documentation/rust_core/latest/)
[![License: MIT](https://img.shields.io/badge/license-MIT-purple.svg)](https://opensource.org/licenses/MIT)
[![Build Status](https://github.com/mcmah309/rust_core/actions/workflows/dart.yml/badge.svg)](https://github.com/mcmah309/rust_core/actions)

`rust_core` is an implementation of Rust's Core Library in Dart.

The goal is to bring Rust's features and ergonomics to Dart. This also provides a seamless developer experience for any developer using both languages.

Rust's functionalities are carefully adapted to Dart's paradigms, focusing on a smooth idiomatic language-compatible integration with predictable control flow.

## Highlights
### Libraries

| [Array] | [Cell] | [Iter] | [Mpsc] | [Option] | [Panic] | [Result] | [Slice] | [Sync] | [Typedefs] |

🔥 **Extensive Extensions:** Dozens of additional extensions with hundreds of methods tailored for Dart. These 
extensions are designed for maximum composability, addressing specific scenarios.

🚀 **Dart Friendly:** Developed with ergonomics in mind. e.g. Dual Support for `Option` and Nullable Types. If a method or extension exists for `Option<T>`,
it's also available for `T?`.

🧪 **Robust Testing:** Every feature tested. Over 500 meaningful tests. Reliability and performance in every feature.

### Official Packages Based Off rust_core
| Library | Description |
| ------- | ----------- |
| [anyhow] | Idiomatic error handling capabilities to make your code safer, more maintainable, and errors easier to debug. |
| [rewind] | A logging utility that allows you completely customize what is captured and how your logs look at each logging level.  |
| [rust_std] | Implementation of Rust's standard library in Dart. |
| [tapper] | Extension methods on all types that allow transparent, temporary, inspection/mutation (tapping), transformation (piping), or type conversion. |
| [thiserror] | A library for concisely defining error types (error enums / sealed classes) and their String representation. |


[Cell]: https://github.com/mcmah309/rust_core/tree/master/lib/src/cell
[Option]: https://github.com/mcmah309/rust_core/tree/master/lib/src/option
[Panic]: https://github.com/mcmah309/rust_core/tree/master/lib/src/panic
[Result]: https://github.com/mcmah309/rust_core/tree/master/lib/src/result
[Typedefs]: https://github.com/mcmah309/rust_core/tree/master/lib/src/typedefs
[Iter]: https://github.com/mcmah309/rust_core/tree/master/lib/src/iter
[Array]: https://github.com/mcmah309/rust_core/tree/master/lib/src/array
[Slice]: https://github.com/mcmah309/rust_core/tree/master/lib/src/slice
[Sync]: https://github.com/mcmah309/rust_core/tree/master/lib/src/sync
[Mpsc]: https://github.com/mcmah309/rust_core/tree/master/lib/src/mpsc


[anyhow]: https://pub.dev/packages/anyhow
[thiserror]: https://pub.dev/packages/thiserror
[rewind]: https://pub.dev/packages/rewind
[rust_std]: https://pub.dev/packages/rust_std
[tapper]: https://pub.dev/packages/tapper