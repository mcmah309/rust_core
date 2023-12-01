import '../../rust_core.dart';



extension RecordToResult22<A,B,Z extends Object> on (Result<A,Z>,Result<B,Z>){
  /// {@template RecordToResult}
  /// Transforms a Record of [Result]s into a single [Result], [Ok] is a Record of all Results [Ok] values, if all are
  /// [Ok], and is [Err] the List of all [Err] values if any are [Err]
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
}

extension RecordToResult2<A,B,Z extends Object> on (Result<A,Z>,Result<B,Z>){
  /// {@macro RecordToResult}
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
}


extension RecordToResult3<A,B,C,Z extends Object> on (Result<A,Z>,Result<B,Z>, Result<C,Z>){
  /// {@macro RecordToResult}
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
}

extension RecordToResult4<A, B, C, D, Z extends Object> on (Result<A, Z>, Result<B, Z>, Result<C, Z>, Result<D, Z>) {
  /// {@macro RecordToResult}
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
}

extension RecordToResult5<A, B, C, D, E, Z extends Object> on (Result<A, Z>, Result<B, Z>, Result<C, Z>, Result<D, Z>, Result<E, Z>) {
  /// {@macro RecordToResult}
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
}

extension RecordToResult6<A, B, C, D, E, F, Z extends Object> on (Result<A, Z>, Result<B, Z>, Result<C, Z>, Result<D, Z>, Result<E, Z>, Result<F, Z>) {
  /// {@macro RecordToResult}
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
}

extension RecordToResult7<A, B, C, D, E, F, G, Z extends Object> on (Result<A, Z>, Result<B, Z>, Result<C, Z>, Result<D, Z>, Result<E, Z>, Result<F, Z>, Result<G, Z>) {
  /// {@macro RecordToResult}
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
}

extension RecordToResult8<A, B, C, D, E, F, G, H, Z extends Object> on (Result<A, Z>, Result<B, Z>, Result<C, Z>, Result<D, Z>, Result<E, Z>, Result<F, Z>, Result<G, Z>, Result<H, Z>) {
  /// {@macro RecordToResult}
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
}

extension RecordToResult9<A, B, C, D, E, F, G, H, I, Z extends Object> on (Result<A, Z>, Result<B, Z>, Result<C, Z>, Result<D, Z>, Result<E, Z>, Result<F, Z>, Result<G, Z>, Result<H, Z>, Result<I, Z>) {
  /// {@macro RecordToResult}
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
}

extension RecordToResult10<A, B, C, D, E, F, G, H, I, J, Z extends Object> on (Result<A, Z>, Result<B, Z>, Result<C, Z>, Result<D, Z>, Result<E, Z>, Result<F, Z>, Result<G, Z>, Result<H, Z>, Result<I, Z>, Result<J, Z>) {
  /// {@macro RecordToResult}
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
}

