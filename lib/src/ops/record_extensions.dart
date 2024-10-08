extension RecordExtension1<A> on (A,) {
  @pragma("vm:prefer-inline")
  (A, Z) add<Z>(Z other) => (this.$1, other);
}

extension RecordExtension2<A, B> on (A, B) {
  @pragma("vm:prefer-inline")
  (A, B, Z) add<Z>(Z other) => (this.$1, this.$2, other);
}

extension RecordExtension3<A, B, C> on (A, B, C) {
  @pragma("vm:prefer-inline")
  (A, B, C, Z) add<Z>(Z other) => (this.$1, this.$2, this.$3, other);
}

extension RecordExtension4<A, B, C, D> on (A, B, C, D) {
  @pragma("vm:prefer-inline")
  (A, B, C, D, Z) add<Z>(Z other) =>
      (this.$1, this.$2, this.$3, this.$4, other);
}

extension RecordExtension5<A, B, C, D, E> on (A, B, C, D, E) {
  @pragma("vm:prefer-inline")
  (A, B, C, D, E, Z) add<Z>(Z other) =>
      (this.$1, this.$2, this.$3, this.$4, this.$5, other);
}

extension RecordExtension6<A, B, C, D, E, F> on (A, B, C, D, E, F) {
  @pragma("vm:prefer-inline")
  (A, B, C, D, E, F, Z) add<Z>(Z other) =>
      (this.$1, this.$2, this.$3, this.$4, this.$5, this.$6, other);
}

extension RecordExtension7<A, B, C, D, E, F, G> on (A, B, C, D, E, F, G) {
  @pragma("vm:prefer-inline")
  (A, B, C, D, E, F, G, Z) add<Z>(Z other) =>
      (this.$1, this.$2, this.$3, this.$4, this.$5, this.$6, this.$7, other);
}

extension RecordExtension8<A, B, C, D, E, F, G, H> on (A, B, C, D, E, F, G, H) {
  @pragma("vm:prefer-inline")
  (A, B, C, D, E, F, G, H, Z) add<Z>(Z other) => (
        this.$1,
        this.$2,
        this.$3,
        this.$4,
        this.$5,
        this.$6,
        this.$7,
        this.$8,
        other
      );
}

extension RecordExtension9<A, B, C, D, E, F, G, H, I> on (
  A,
  B,
  C,
  D,
  E,
  F,
  G,
  H,
  I
) {
  @pragma("vm:prefer-inline")
  (A, B, C, D, E, F, G, H, I, Z) add<Z>(Z other) => (
        this.$1,
        this.$2,
        this.$3,
        this.$4,
        this.$5,
        this.$6,
        this.$7,
        this.$8,
        this.$9,
        other
      );
}

extension RecordExtension10<A, B, C, D, E, F, G, H, I, J> on (
  A,
  B,
  C,
  D,
  E,
  F,
  G,
  H,
  I,
  J
) {
  @pragma("vm:prefer-inline")
  (A, B, C, D, E, F, G, H, I, J, Z) add<Z>(Z other) => (
        this.$1,
        this.$2,
        this.$3,
        this.$4,
        this.$5,
        this.$6,
        this.$7,
        this.$8,
        this.$9,
        this.$10,
        other
      );
}
