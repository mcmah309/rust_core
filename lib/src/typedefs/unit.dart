import '../../rust_core.dart';

/// Type alias for (). Used for a [Result] when the returned value does not matter. Preferred over void since
/// forces stricter types. See [unit], [okay], and [error]
typedef Unit = ();

const unit = ();
const okay = Ok(unit);
const error = Err(unit);
