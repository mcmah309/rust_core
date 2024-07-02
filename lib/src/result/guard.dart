import 'dart:async';

import 'package:rust_core/result.dart';

/// Executes the function in a protected context. [func] is called inside a try catch block. If the result does not
/// catch, then return value [func] returned inside an [Ok]. If [func] throws, then the thrown value is returned
/// inside an [Err].
@pragma("vm:prefer-inline")
Result<S, Object> guard<S>(S Function() func) {
  assert(S is! Result, "Use guardResult instead");
  try {
    return Ok(func());
  } catch (e) {
    return Err(e);
  }
}

/// Result unwrapping version of [guard]. Where [func] returns an [Result], but can still throw.
@pragma("vm:prefer-inline")
Result<S, Object> guardResult<S>(Result<S, Object> Function() func) {
  try {
    return func();
  } catch (e) {
    return Err(e);
  }
}

/// Async version of [guard]
@pragma("vm:prefer-inline")
FutureResult<S, Object> guardAsync<S>(Future<S> Function() func) async {
  assert(S is! Result, "Use guardAsyncResult instead");
  try {
    return Ok(await func());
  } catch (e) {
    return Err(e);
  }
}

/// Async version of [guardResult]
@pragma("vm:prefer-inline")
FutureResult<S, Object> guardAsyncResult<S>(
    Future<Result<S, Object>> Function() func) async {
  try {
    return await func();
  } catch (e) {
    return Err(e);
  }
}
