# Demo

## Install

rust_core can be install like any other Dart package.

Dart:
```shell
dart pub add rust_core
```
Flutter:
```shell
flutter pub add rust_core
```

or add directly to your `pubspec.yaml`:
```yaml
dependencies:
  rust_core: <version>
```

## Usage

rust_core follows the same library structure and naming as [Rust's rust_core](https://doc.rust-lang.org/core/).

To that extent, each library can be imported individually
```dart
import 'package:rust_core/result.dart';
```
or in it's entirety
```dart
import 'package:rust_core/rust_core.dart';
```

In action