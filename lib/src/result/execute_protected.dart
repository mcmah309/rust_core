import 'dart:async';

import '../../rust_core.dart';

/// Executes the function in a protected context. [func] is called inside a try catch block. If the result is not
/// catch, then return value [func] returned inside an [Ok]. If [func] throws, then the thrown value is returned
/// inside an [Err].
Result<S, Object> executeProtected<S>(S Function() func) {
  assert(S is! Result, "Use executeProtectedResult instead");
  try {
    return Ok(func());
  } catch (e) {
    return Err(e);
  }
}

/// Result unwrapping version of [executeProtected]. Where [func] returns an [Result], but can still throw.
Result<S, Object> executeProtectedResult<S>(Result<S, Object> Function() func) {
  try {
    return func();
  } catch (e) {
    return Err(e);
  }
}

/// Async version of [executeProtected]
FutureResult<S, Object> executeProtectedAsync<S>(
    Future<S> Function() func) async {
  assert(S is! Result, "Use executeProtectedAsyncResult instead");
  try {
    return Ok(await func());
  } catch (e) {
    return Err(e);
  }
}

/// Async version of [executeProtectedResult]
FutureResult<S, Object> executeProtectedAsyncResult<S>(
    Future<Result<S, Object>> Function() func) async {
  try {
    return await func();
  } catch (e) {
    return Err(e);
  }
}
