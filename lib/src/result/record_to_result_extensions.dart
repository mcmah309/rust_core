
import 'package:rust_core/result.dart';


extension RecordToResult2<A,B,Z extends Object> on (Result<A,Z>,Result<B,Z>){
  /// {@template RecordToResult.toResult}
  /// Transforms a Record of [Result]s into a single [Result]. The [Ok] value is a Record of all Result's [Ok]
  /// values. The [Err] value is the List of all [Err] values.
  ///
  /// Instead of writing code like this
  ///```
  ///     final a, b, c;
  ///     final boolResult = boolOk();
  ///     switch(boolResult){
  ///       case Ok(:final ok):
  ///         a = ok;
  ///       case Err():
  ///         return boolResult;
  ///     }
  ///     final intResult = intOk();
  ///     switch(intResult){
  ///       case Ok(:final ok):
  ///         b = ok;
  ///       case Err():
  ///         return intResult;
  ///     }
  ///     final doubleResult = doubleOk();
  ///     switch(doubleResult){
  ///       case Ok(:final ok):
  ///         c = ok;
  ///       case Err():
  ///         return doubleResult;
  ///     }
  ///```
  /// You can now write it like this
  /// ```
  ///     final a, b, c;
  ///     switch((boolOk(), intOk(), doubleOk()).toResult()){
  ///       case Ok(:final ok):
  ///         (a, b, c) = ok;
  ///       case Err():
  ///         throw Exception();
  ///     }
  ///```
  /// {@endtemplate}
  Result<(A, B), List<Z>> toResult(){
    List<Z> z = [];
    A? a;
    if($1.isOk()) {
      a = $1.unwrap();
    }
    else{
      z.add($1.unwrapErr());
    }
    B? b;
    if($2.isOk()) {
      b = $2.unwrap();
    }else{
      z.add($2.unwrapErr());
    }

    if(z.isEmpty){
      return Ok((a!, b!));
    } else {
      return Err(z);
    }
  }

  /// {@template RecordToResult.toResultEager}
  /// Transforms a Record of [Result]s into a single [Result]. The [Ok] value is a Record of all Result's [Ok]
  /// values. The [Err] value is the first [Err] encountered.
  ///
  /// Instead of writing code like this
  ///```
  ///     final a, b, c;
  ///     final boolResult = boolOk();
  ///     switch(boolResult){
  ///       case Ok(:final ok):
  ///         a = ok;
  ///       case Err():
  ///         return boolResult;
  ///     }
  ///     final intResult = intOk();
  ///     switch(intResult){
  ///       case Ok(:final ok):
  ///         b = ok;
  ///       case Err():
  ///         return intResult;
  ///     }
  ///     final doubleResult = doubleOk();
  ///     switch(doubleResult){
  ///       case Ok(:final ok):
  ///         c = ok;
  ///       case Err():
  ///         return doubleResult;
  ///     }
  ///```
  /// You can now write it like this
  /// ```
  ///     final a, b, c;
  ///     switch((boolOk(), intOk(), doubleOk()).toResultEager()){
  ///       case Ok(:final ok):
  ///         (a, b, c) = ok;
  ///       case Err():
  ///         throw Exception();
  ///     }
  ///```
  /// {@endtemplate}
  Result<(A, B), Z> toResultEager(){
    A a;
    if($1.isOk()) {
      a = $1.unwrap();
    }
    else{
      return $1.intoUnchecked();
    }
    B b;
    if($2.isOk()) {
      b = $2.unwrap();
    }else{
      return $2.intoUnchecked();
    }

    return Ok((a, b));
  }
}


extension RecordToResult3<A,B,C,Z extends Object> on (Result<A,Z>,Result<B,Z>, Result<C,Z>){
  /// {@macro RecordToResult.toResult}
  Result<(A, B, C), List<Z>> toResult(){
    List<Z> z = [];
    A? a;
    if($1.isOk()) {
      a = $1.unwrap();
    }
    else{
      z.add($1.unwrapErr());
    }
    B? b;
    if($2.isOk()) {
      b = $2.unwrap();
    }else{
      z.add($2.unwrapErr());
    }
    C? c;
    if($3.isOk()) {
      c = $3.unwrap();
    }
    else{
      z.add($3.unwrapErr());
    }

    if(z.isEmpty){
      return Ok((a!, b!, c!));
    } else {
      return Err(z);
    }
  }

  /// {@macro RecordToResult.toResultEager}
  Result<(A, B, C), Z> toResultEager(){
    A a;
    if($1.isOk()) {
      a = $1.unwrap();
    }
    else{
      return $1.intoUnchecked();
    }
    B b;
    if($2.isOk()) {
      b = $2.unwrap();
    }else{
      return $2.intoUnchecked();
    }
    C c;
    if($3.isOk()) {
      c = $3.unwrap();
    }else{
      return $3.intoUnchecked();
    }

    return Ok((a, b, c));
  }
}

extension RecordToResult4<A, B, C, D, Z extends Object> on (Result<A, Z>, Result<B, Z>, Result<C, Z>, Result<D, Z>) {
  /// {@macro RecordToResult.toResult}
  Result<(A, B, C, D), List<Z>> toResult() {
    List<Z> z = [];
    A? a;
    if ($1.isOk()) {
      a = $1.unwrap();
    } else {
      z.add($1.unwrapErr());
    }
    B? b;
    if ($2.isOk()) {
      b = $2.unwrap();
    } else {
      z.add($2.unwrapErr());
    }
    C? c;
    if ($3.isOk()) {
      c = $3.unwrap();
    } else {
      z.add($3.unwrapErr());
    }
    D? d;
    if ($4.isOk()) {
      d = $4.unwrap();
    } else {
      z.add($4.unwrapErr());
    }

    if (z.isEmpty) {
      return Ok((a!, b!, c!, d!));
    } else {
      return Err(z);
    }
  }

  /// {@macro RecordToResult.toResultEager}
  Result<(A, B, C, D), Z> toResultEager(){
    A a;
    if($1.isOk()) {
      a = $1.unwrap();
    }
    else{
      return $1.intoUnchecked();
    }

    B b;
    if($2.isOk()) {
      b = $2.unwrap();
    }else{
      return $2.intoUnchecked();
    }

    C c;
    if($3.isOk()) {
      c = $3.unwrap();
    }else{
      return $3.intoUnchecked();
    }

    D d;
    if($4.isOk()) {
      d = $4.unwrap();
    }else{
      return $4.intoUnchecked();
    }

    return Ok((a, b, c, d));
  }
}

extension RecordToResult5<A, B, C, D, E, Z extends Object> on (Result<A, Z>, Result<B, Z>, Result<C, Z>, Result<D, Z>, Result<E, Z>) {
  /// {@macro RecordToResult.toResult}
  Result<(A, B, C, D, E), List<Z>> toResult() {
    List<Z> z = [];
    A? a;
    if ($1.isOk()) {
      a = $1.unwrap();
    } else {
      z.add($1.unwrapErr());
    }
    B? b;
    if ($2.isOk()) {
      b = $2.unwrap();
    } else {
      z.add($2.unwrapErr());
    }
    C? c;
    if ($3.isOk()) {
      c = $3.unwrap();
    } else {
      z.add($3.unwrapErr());
    }
    D? d;
    if ($4.isOk()) {
      d = $4.unwrap();
    } else {
      z.add($4.unwrapErr());
    }
    E? e;
    if ($5.isOk()) {
      e = $5.unwrap();
    } else {
      z.add($5.unwrapErr());
    }

    if (z.isEmpty) {
      return Ok((a!, b!, c!, d!, e!));
    } else {
      return Err(z);
    }
  }

  /// {@macro RecordToResult.toResultEager}
  Result<(A, B, C, D, E), Z> toResultEager(){
    A a;
    if($1.isOk()) {
      a = $1.unwrap();
    }
    else{
      return $1.intoUnchecked();
    }

    B b;
    if($2.isOk()) {
      b = $2.unwrap();
    } else {
      return $2.intoUnchecked();
    }

    C c;
    if($3.isOk()) {
      c = $3.unwrap();
    } else {
      return $3.intoUnchecked();
    }

    D d;
    if($4.isOk()) {
      d = $4.unwrap();
    } else {
      return $4.intoUnchecked();
    }

    E e;
    if($5.isOk()) {
      e = $5.unwrap();
    } else {
      return $5.intoUnchecked();
    }

    return Ok((a, b, c, d, e));
  }
}

extension RecordToResult6<A, B, C, D, E, F, Z extends Object> on (Result<A, Z>, Result<B, Z>, Result<C, Z>, Result<D, Z>, Result<E, Z>, Result<F, Z>) {
  /// {@macro RecordToResult.toResult}
  Result<(A, B, C, D, E, F), List<Z>> toResult() {
    List<Z> z = [];
    A? a;
    if ($1.isOk()) {
      a = $1.unwrap();
    } else {
      z.add($1.unwrapErr());
    }
    B? b;
    if ($2.isOk()) {
      b = $2.unwrap();
    } else {
      z.add($2.unwrapErr());
    }
    C? c;
    if ($3.isOk()) {
      c = $3.unwrap();
    } else {
      z.add($3.unwrapErr());
    }
    D? d;
    if ($4.isOk()) {
      d = $4.unwrap();
    } else {
      z.add($4.unwrapErr());
    }
    E? e;
    if ($5.isOk()) {
      e = $5.unwrap();
    } else {
      z.add($5.unwrapErr());
    }
    F? f;
    if ($6.isOk()) {
      f = $6.unwrap();
    } else {
      z.add($6.unwrapErr());
    }

    if (z.isEmpty) {
      return Ok((a!, b!, c!, d!, e!, f!));
    } else {
      return Err(z);
    }
  }

  /// {@macro RecordToResult.toResultEager}
  Result<(A, B, C, D, E, F), Z> toResultEager(){
    A a;
    if($1.isOk()) {
      a = $1.unwrap();
    }
    else{
      return $1.intoUnchecked();
    }

    B b;
    if($2.isOk()) {
      b = $2.unwrap();
    } else {
      return $2.intoUnchecked();
    }

    C c;
    if($3.isOk()) {
      c = $3.unwrap();
    } else {
      return $3.intoUnchecked();
    }

    D d;
    if($4.isOk()) {
      d = $4.unwrap();
    } else {
      return $4.intoUnchecked();
    }

    E e;
    if($5.isOk()) {
      e = $5.unwrap();
    } else {
      return $5.intoUnchecked();
    }

    F f;
    if($6.isOk()) {
      f = $6.unwrap();
    } else {
      return $6.intoUnchecked();
    }

    return Ok((a, b, c, d, e, f));
  }
}

extension RecordToResult7<A, B, C, D, E, F, G, Z extends Object> on (Result<A, Z>, Result<B, Z>, Result<C, Z>, Result<D, Z>, Result<E, Z>, Result<F, Z>, Result<G, Z>) {
  /// {@macro RecordToResult.toResult}
  Result<(A, B, C, D, E, F, G), List<Z>> toResult() {
    List<Z> z = [];
    A? a;
    if ($1.isOk()) {
      a = $1.unwrap();
    } else {
      z.add($1.unwrapErr());
    }
    B? b;
    if ($2.isOk()) {
      b = $2.unwrap();
    } else {
      z.add($2.unwrapErr());
    }
    C? c;
    if ($3.isOk()) {
      c = $3.unwrap();
    } else {
      z.add($3.unwrapErr());
    }
    D? d;
    if ($4.isOk()) {
      d = $4.unwrap();
    } else {
      z.add($4.unwrapErr());
    }
    E? e;
    if ($5.isOk()) {
      e = $5.unwrap();
    } else {
      z.add($5.unwrapErr());
    }
    F? f;
    if ($6.isOk()) {
      f = $6.unwrap();
    } else {
      z.add($6.unwrapErr());
    }
    G? g;
    if ($7.isOk()) {
      g = $7.unwrap();
    } else {
      z.add($7.unwrapErr());
    }

    if (z.isEmpty) {
      return Ok((a!, b!, c!, d!, e!, f!, g!));
    } else {
      return Err(z);
    }
  }

  /// {@macro RecordToResult.toResultEager}
  Result<(A, B, C, D, E, F, G), Z> toResultEager(){
    A a;
    if($1.isOk()) {
      a = $1.unwrap();
    }
    else{
      return $1.intoUnchecked();
    }

    B b;
    if($2.isOk()) {
      b = $2.unwrap();
    } else {
      return $2.intoUnchecked();
    }

    C c;
    if($3.isOk()) {
      c = $3.unwrap();
    } else {
      return $3.intoUnchecked();
    }

    D d;
    if($4.isOk()) {
      d = $4.unwrap();
    } else {
      return $4.intoUnchecked();
    }

    E e;
    if($5.isOk()) {
      e = $5.unwrap();
    } else {
      return $5.intoUnchecked();
    }

    F f;
    if($6.isOk()) {
      f = $6.unwrap();
    } else {
      return $6.intoUnchecked();
    }

    G g;
    if($7.isOk()) {
      g = $7.unwrap();
    } else {
      return $7.intoUnchecked();
    }

    return Ok((a, b, c, d, e, f, g));
  }
}

extension RecordToResult8<A, B, C, D, E, F, G, H, Z extends Object> on (Result<A, Z>, Result<B, Z>, Result<C, Z>, Result<D, Z>, Result<E, Z>, Result<F, Z>, Result<G, Z>, Result<H, Z>) {
  /// {@macro RecordToResult.toResult}
  Result<(A, B, C, D, E, F, G, H), List<Z>> toResult() {
    List<Z> z = [];
    A? a;
    if ($1.isOk()) {
      a = $1.unwrap();
    } else {
      z.add($1.unwrapErr());
    }
    B? b;
    if ($2.isOk()) {
      b = $2.unwrap();
    } else {
      z.add($2.unwrapErr());
    }
    C? c;
    if ($3.isOk()) {
      c = $3.unwrap();
    } else {
      z.add($3.unwrapErr());
    }
    D? d;
    if ($4.isOk()) {
      d = $4.unwrap();
    } else {
      z.add($4.unwrapErr());
    }
    E? e;
    if ($5.isOk()) {
      e = $5.unwrap();
    } else {
      z.add($5.unwrapErr());
    }
    F? f;
    if ($6.isOk()) {
      f = $6.unwrap();
    } else {
      z.add($6.unwrapErr());
    }
    G? g;
    if ($7.isOk()) {
      g = $7.unwrap();
    } else {
      z.add($7.unwrapErr());
    }
    H? h;
    if ($8.isOk()) {
      h = $8.unwrap();
    } else {
      z.add($8.unwrapErr());
    }

    if (z.isEmpty) {
      return Ok((a!, b!, c!, d!, e!, f!, g!, h!));
    } else {
      return Err(z);
    }
  }

  /// {@macro RecordToResult.toResultEager}
  Result<(A, B, C, D, E, F, G, H), Z> toResultEager(){
    A a;
    if($1.isOk()) {
      a = $1.unwrap();
    }
    else{
      return $1.intoUnchecked();
    }

    B b;
    if($2.isOk()) {
      b = $2.unwrap();
    } else {
      return $2.intoUnchecked();
    }

    C c;
    if($3.isOk()) {
      c = $3.unwrap();
    } else {
      return $3.intoUnchecked();
    }

    D d;
    if($4.isOk()) {
      d = $4.unwrap();
    } else {
      return $4.intoUnchecked();
    }

    E e;
    if($5.isOk()) {
      e = $5.unwrap();
    } else {
      return $5.intoUnchecked();
    }

    F f;
    if($6.isOk()) {
      f = $6.unwrap();
    } else {
      return $6.intoUnchecked();
    }

    G g;
    if($7.isOk()) {
      g = $7.unwrap();
    } else {
      return $7.intoUnchecked();
    }

    H h;
    if($8.isOk()) {
      h = $8.unwrap();
    } else {
      return $8.intoUnchecked();
    }

    return Ok((a, b, c, d, e, f, g, h));
  }
}

extension RecordToResult9<A, B, C, D, E, F, G, H, I, Z extends Object> on (Result<A, Z>, Result<B, Z>, Result<C, Z>, Result<D, Z>, Result<E, Z>, Result<F, Z>, Result<G, Z>, Result<H, Z>, Result<I, Z>) {
  /// {@macro RecordToResult.toResult}
  Result<(A, B, C, D, E, F, G, H, I), List<Z>> toResult() {
    List<Z> z = [];
    A? a;
    if ($1.isOk()) {
      a = $1.unwrap();
    } else {
      z.add($1.unwrapErr());
    }
    B? b;
    if ($2.isOk()) {
      b = $2.unwrap();
    } else {
      z.add($2.unwrapErr());
    }
    C? c;
    if ($3.isOk()) {
      c = $3.unwrap();
    } else {
      z.add($3.unwrapErr());
    }
    D? d;
    if ($4.isOk()) {
      d = $4.unwrap();
    } else {
      z.add($4.unwrapErr());
    }
    E? e;
    if ($5.isOk()) {
      e = $5.unwrap();
    } else {
      z.add($5.unwrapErr());
    }
    F? f;
    if ($6.isOk()) {
      f = $6.unwrap();
    } else {
      z.add($6.unwrapErr());
    }
    G? g;
    if ($7.isOk()) {
      g = $7.unwrap();
    } else {
      z.add($7.unwrapErr());
    }
    H? h;
    if ($8.isOk()) {
      h = $8.unwrap();
    } else {
      z.add($8.unwrapErr());
    }
    I? i;
    if ($9.isOk()) {
      i = $9.unwrap();
    } else {
      z.add($9.unwrapErr());
    }

    if (z.isEmpty) {
      return Ok((a!, b!, c!, d!, e!, f!, g!, h!, i!));
    } else {
      return Err(z);
    }
  }

  /// {@macro RecordToResult.toResultEager}
  Result<(A, B, C, D, E, F, G, H, I), Z> toResultEager(){
    A a;
    if($1.isOk()) {
      a = $1.unwrap();
    }
    else{
      return $1.intoUnchecked();
    }

    B b;
    if($2.isOk()) {
      b = $2.unwrap();
    } else {
      return $2.intoUnchecked();
    }

    C c;
    if($3.isOk()) {
      c = $3.unwrap();
    } else {
      return $3.intoUnchecked();
    }

    D d;
    if($4.isOk()) {
      d = $4.unwrap();
    } else {
      return $4.intoUnchecked();
    }

    E e;
    if($5.isOk()) {
      e = $5.unwrap();
    } else {
      return $5.intoUnchecked();
    }

    F f;
    if($6.isOk()) {
      f = $6.unwrap();
    } else {
      return $6.intoUnchecked();
    }

    G g;
    if($7.isOk()) {
      g = $7.unwrap();
    } else {
      return $7.intoUnchecked();
    }

    H h;
    if($8.isOk()) {
      h = $8.unwrap();
    } else {
      return $8.intoUnchecked();
    }

    I i;
    if($9.isOk()) {
      i = $9.unwrap();
    } else {
      return $9.intoUnchecked();
    }

    return Ok((a, b, c, d, e, f, g, h, i));
  }
}

extension RecordToResult10<A, B, C, D, E, F, G, H, I, J, Z extends Object> on (Result<A, Z>, Result<B, Z>, Result<C, Z>, Result<D, Z>, Result<E, Z>, Result<F, Z>, Result<G, Z>, Result<H, Z>, Result<I, Z>, Result<J, Z>) {
  /// {@macro RecordToResult.toResult}
  Result<(A, B, C, D, E, F, G, H, I, J), List<Z>> toResult() {
    List<Z> z = [];
    A? a;
    if ($1.isOk()) {
      a = $1.unwrap();
    } else {
      z.add($1.unwrapErr());
    }
    B? b;
    if ($2.isOk()) {
      b = $2.unwrap();
    } else {
      z.add($2.unwrapErr());
    }
    C? c;
    if ($3.isOk()) {
      c = $3.unwrap();
    } else {
      z.add($3.unwrapErr());
    }
    D? d;
    if ($4.isOk()) {
      d = $4.unwrap();
    } else {
      z.add($4.unwrapErr());
    }
    E? e;
    if ($5.isOk()) {
      e = $5.unwrap();
    } else {
      z.add($5.unwrapErr());
    }
    F? f;
    if ($6.isOk()) {
      f = $6.unwrap();
    } else {
      z.add($6.unwrapErr());
    }
    G? g;
    if ($7.isOk()) {
      g = $7.unwrap();
    } else {
      z.add($7.unwrapErr());
    }
    H? h;
    if ($8.isOk()) {
      h = $8.unwrap();
    } else {
      z.add($8.unwrapErr());
    }
    I? i;
    if ($9.isOk()) {
      i = $9.unwrap();
    } else {
      z.add($9.unwrapErr());
    }
    J? j;
    if ($10.isOk()) {
      j = $10.unwrap();
    } else {
      z.add($10.unwrapErr());
    }

    if (z.isEmpty) {
      return Ok((a!, b!, c!, d!, e!, f!, g!, h!, i!, j!));
    } else {
      return Err(z);
    }
  }

  /// {@macro RecordToResult.toResultEager}
  Result<(A, B, C, D, E, F, G, H, I, J), Z> toResultEager(){
    A a;
    if($1.isOk()) {
      a = $1.unwrap();
    }
    else{
      return $1.intoUnchecked();
    }

    B b;
    if($2.isOk()) {
      b = $2.unwrap();
    } else {
      return $2.intoUnchecked();
    }

    C c;
    if($3.isOk()) {
      c = $3.unwrap();
    } else {
      return $3.intoUnchecked();
    }

    D d;
    if($4.isOk()) {
      d = $4.unwrap();
    } else {
      return $4.intoUnchecked();
    }

    E e;
    if($5.isOk()) {
      e = $5.unwrap();
    } else {
      return $5.intoUnchecked();
    }

    F f;
    if($6.isOk()) {
      f = $6.unwrap();
    } else {
      return $6.intoUnchecked();
    }

    G g;
    if($7.isOk()) {
      g = $7.unwrap();
    } else {
      return $7.intoUnchecked();
    }

    H h;
    if($8.isOk()) {
      h = $8.unwrap();
    } else {
      return $8.intoUnchecked();
    }

    I i;
    if($9.isOk()) {
      i = $9.unwrap();
    } else {
      return $9.intoUnchecked();
    }

    J j;
    if($10.isOk()) {
      j = $10.unwrap();
    } else {
      return $10.intoUnchecked();
    }

    return Ok((a, b, c, d, e, f, g, h, i, j));
  }
}

