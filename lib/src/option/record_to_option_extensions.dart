part of 'option.dart';

extension RecordToOption2<A, B> on (Option<A>, Option<B>) {
  Option<(A, B)> toOption() {
    final a = $1.v;
    if (a == null) {
      return None;
    }
    final b = $2.v;
    if (b == null) {
      return None;
    }

    return Some((a, b));
  }
}

extension RecordToOption3<A, B, C> on (
  Option<A>,
  Option<B>,
  Option<C>,
) {
  Option<(A, B, C)> toOption() {
    final a = $1.v;
    if (a == null) {
      return None;
    }
    final b = $2.v;
    if (b == null) {
      return None;
    }
    final c = $3.v;
    if (c == null) {
      return None;
    }

    return Some((a, b, c));
  }
}

extension RecordToOption4<A, B, C, D> on (
  Option<A>,
  Option<B>,
  Option<C>,
  Option<D>,
) {
  Option<(A, B, C, D)> toOption() {
    final a = $1.v;
    if (a == null) {
      return None;
    }
    final b = $2.v;
    if (b == null) {
      return None;
    }
    final c = $3.v;
    if (c == null) {
      return None;
    }
    final d = $4.v;
    if (d == null) {
      return None;
    }

    return Some((a, b, c, d));
  }
}

extension RecordToOption5<A, B, C, D, E> on (
  Option<A>,
  Option<B>,
  Option<C>,
  Option<D>,
  Option<E>,
) {
  Option<(A, B, C, D, E)> toOption() {
    final a = $1.v;
    if (a == null) {
      return None;
    }
    final b = $2.v;
    if (b == null) {
      return None;
    }
    final c = $3.v;
    if (c == null) {
      return None;
    }
    final d = $4.v;
    if (d == null) {
      return None;
    }
    final e = $5.v;
    if (e == null) {
      return None;
    }

    return Some((a, b, c, d, e));
  }
}

extension RecordToOption6<A, B, C, D, E, F> on (
  Option<A>,
  Option<B>,
  Option<C>,
  Option<D>,
  Option<E>,
  Option<F>,
) {
  Option<(A, B, C, D, E, F)> toOption() {
    final a = $1.v;
    if (a == null) {
      return None;
    }
    final b = $2.v;
    if (b == null) {
      return None;
    }
    final c = $3.v;
    if (c == null) {
      return None;
    }
    final d = $4.v;
    if (d == null) {
      return None;
    }
    final e = $5.v;
    if (e == null) {
      return None;
    }
    final f = $6.v;
    if (f == null) {
      return None;
    }

    return Some((a, b, c, d, e, f));
  }
}

extension RecordToOption7<A, B, C, D, E, F, G> on (
  Option<A>,
  Option<B>,
  Option<C>,
  Option<D>,
  Option<E>,
  Option<F>,
  Option<G>,
) {
  Option<(A, B, C, D, E, F, G)> toOption() {
    final a = $1.v;
    if (a == null) {
      return None;
    }
    final b = $2.v;
    if (b == null) {
      return None;
    }
    final c = $3.v;
    if (c == null) {
      return None;
    }
    final d = $4.v;
    if (d == null) {
      return None;
    }
    final e = $5.v;
    if (e == null) {
      return None;
    }
    final f = $6.v;
    if (f == null) {
      return None;
    }
    final g = $7.v;
    if (g == null) {
      return None;
    }

    return Some((a, b, c, d, e, f, g));
  }
}

extension RecordToOption8<A, B, C, D, E, F, G, H> on (
  Option<A>,
  Option<B>,
  Option<C>,
  Option<D>,
  Option<E>,
  Option<F>,
  Option<G>,
  Option<H>,
) {
  Option<(A, B, C, D, E, F, G, H)> toOption() {
    final a = $1.v;
    if (a == null) {
      return None;
    }
    final b = $2.v;
    if (b == null) {
      return None;
    }
    final c = $3.v;
    if (c == null) {
      return None;
    }
    final d = $4.v;
    if (d == null) {
      return None;
    }
    final e = $5.v;
    if (e == null) {
      return None;
    }
    final f = $6.v;
    if (f == null) {
      return None;
    }
    final g = $7.v;
    if (g == null) {
      return None;
    }
    final h = $8.v;
    if (h == null) {
      return None;
    }

    return Some((a, b, c, d, e, f, g, h));
  }
}

extension RecordToOption9<A, B, C, D, E, F, G, H, I> on (
  Option<A>,
  Option<B>,
  Option<C>,
  Option<D>,
  Option<E>,
  Option<F>,
  Option<G>,
  Option<H>,
  Option<I>,
) {
  Option<(A, B, C, D, E, F, G, H, I)> toOption() {
    final a = $1.v;
    if (a == null) {
      return None;
    }
    final b = $2.v;
    if (b == null) {
      return None;
    }
    final c = $3.v;
    if (c == null) {
      return None;
    }
    final d = $4.v;
    if (d == null) {
      return None;
    }
    final e = $5.v;
    if (e == null) {
      return None;
    }
    final f = $6.v;
    if (f == null) {
      return None;
    }
    final g = $7.v;
    if (g == null) {
      return None;
    }
    final h = $8.v;
    if (h == null) {
      return None;
    }
    final i = $9.v;
    if (i == null) {
      return None;
    }

    return Some((a, b, c, d, e, f, g, h, i));
  }
}

extension RecordToOption10<A, B, C, D, E, F, G, H, I, J> on (
  Option<A>,
  Option<B>,
  Option<C>,
  Option<D>,
  Option<E>,
  Option<F>,
  Option<G>,
  Option<H>,
  Option<I>,
  Option<J>,
) {
  Option<(A, B, C, D, E, F, G, H, I, J)> toOption() {
    final a = $1.v;
    if (a == null) {
      return None;
    }
    final b = $2.v;
    if (b == null) {
      return None;
    }
    final c = $3.v;
    if (c == null) {
      return None;
    }
    final d = $4.v;
    if (d == null) {
      return None;
    }
    final e = $5.v;
    if (e == null) {
      return None;
    }
    final f = $6.v;
    if (f == null) {
      return None;
    }
    final g = $7.v;
    if (g == null) {
      return None;
    }
    final h = $8.v;
    if (h == null) {
      return None;
    }
    final i = $9.v;
    if (i == null) {
      return None;
    }
    final j = $10.v;
    if (j == null) {
      return None;
    }

    return Some((a, b, c, d, e, f, g, h, i, j));
  }
}

//************************************************************************//

extension RecordFunctionToOption2<A, B> on (
  Option<A> Function(),
  Option<B> Function()
) {
  Option<(A, B)> toOption() {
    final a = $1().v;
    if (a == null) {
      return None;
    }
    final b = $2().v;
    if (b == null) {
      return None;
    }

    return Some((a, b));
  }
}

extension RecordFunctionToOption3<A, B, C> on (
  Option<A> Function(),
  Option<B> Function(),
  Option<C> Function()
) {
  Option<(A, B, C)> toOption() {
    final a = $1().v;
    if (a == null) {
      return None;
    }
    final b = $2().v;
    if (b == null) {
      return None;
    }
    final c = $3().v;
    if (c == null) {
      return None;
    }

    return Some((a, b, c));
  }
}

extension RecordFunctionToOption4<A, B, C, D> on (
  Option<A> Function(),
  Option<B> Function(),
  Option<C> Function(),
  Option<D> Function()
) {
  Option<(A, B, C, D)> toOption() {
    final a = $1().v;
    if (a == null) {
      return None;
    }
    final b = $2().v;
    if (b == null) {
      return None;
    }
    final c = $3().v;
    if (c == null) {
      return None;
    }
    final d = $4().v;
    if (d == null) {
      return None;
    }

    return Some((a, b, c, d));
  }
}

extension RecordFunctionToOption5<A, B, C, D, E> on (
  Option<A> Function(),
  Option<B> Function(),
  Option<C> Function(),
  Option<D> Function(),
  Option<E> Function()
) {
  Option<(A, B, C, D, E)> toOption() {
    final a = $1().v;
    if (a == null) {
      return None;
    }
    final b = $2().v;
    if (b == null) {
      return None;
    }
    final c = $3().v;
    if (c == null) {
      return None;
    }
    final d = $4().v;
    if (d == null) {
      return None;
    }
    final e = $5().v;
    if (e == null) {
      return None;
    }

    return Some((a, b, c, d, e));
  }
}

extension RecordFunctionToOption6<A, B, C, D, E, F> on (
  Option<A> Function(),
  Option<B> Function(),
  Option<C> Function(),
  Option<D> Function(),
  Option<E> Function(),
  Option<F> Function()
) {
  Option<(A, B, C, D, E, F)> toOption() {
    final a = $1().v;
    if (a == null) {
      return None;
    }
    final b = $2().v;
    if (b == null) {
      return None;
    }
    final c = $3().v;
    if (c == null) {
      return None;
    }
    final d = $4().v;
    if (d == null) {
      return None;
    }
    final e = $5().v;
    if (e == null) {
      return None;
    }
    final f = $6().v;
    if (f == null) {
      return None;
    }

    return Some((a, b, c, d, e, f));
  }
}

extension RecordFunctionToOption7<A, B, C, D, E, F, G> on (
  Option<A> Function(),
  Option<B> Function(),
  Option<C> Function(),
  Option<D> Function(),
  Option<E> Function(),
  Option<F> Function(),
  Option<G> Function()
) {
  Option<(A, B, C, D, E, F, G)> toOption() {
    final a = $1().v;
    if (a == null) {
      return None;
    }
    final b = $2().v;
    if (b == null) {
      return None;
    }
    final c = $3().v;
    if (c == null) {
      return None;
    }
    final d = $4().v;
    if (d == null) {
      return None;
    }
    final e = $5().v;
    if (e == null) {
      return None;
    }
    final f = $6().v;
    if (f == null) {
      return None;
    }
    final g = $7().v;
    if (g == null) {
      return None;
    }

    return Some((a, b, c, d, e, f, g));
  }
}

extension RecordFunctionToOption8<A, B, C, D, E, F, G, H> on (
  Option<A> Function(),
  Option<B> Function(),
  Option<C> Function(),
  Option<D> Function(),
  Option<E> Function(),
  Option<F> Function(),
  Option<G> Function(),
  Option<H> Function()
) {
  Option<(A, B, C, D, E, F, G, H)> toOption() {
    final a = $1().v;
    if (a == null) {
      return None;
    }
    final b = $2().v;
    if (b == null) {
      return None;
    }
    final c = $3().v;
    if (c == null) {
      return None;
    }
    final d = $4().v;
    if (d == null) {
      return None;
    }
    final e = $5().v;
    if (e == null) {
      return None;
    }
    final f = $6().v;
    if (f == null) {
      return None;
    }
    final g = $7().v;
    if (g == null) {
      return None;
    }
    final h = $8().v;
    if (h == null) {
      return None;
    }

    return Some((a, b, c, d, e, f, g, h));
  }
}

extension RecordFunctionToOption9<A, B, C, D, E, F, G, H, I> on (
  Option<A> Function(),
  Option<B> Function(),
  Option<C> Function(),
  Option<D> Function(),
  Option<E> Function(),
  Option<F> Function(),
  Option<G> Function(),
  Option<H> Function(),
  Option<I> Function()
) {
  Option<(A, B, C, D, E, F, G, H, I)> toOption() {
    final a = $1().v;
    if (a == null) {
      return None;
    }
    final b = $2().v;
    if (b == null) {
      return None;
    }
    final c = $3().v;
    if (c == null) {
      return None;
    }
    final d = $4().v;
    if (d == null) {
      return None;
    }
    final e = $5().v;
    if (e == null) {
      return None;
    }
    final f = $6().v;
    if (f == null) {
      return None;
    }
    final g = $7().v;
    if (g == null) {
      return None;
    }
    final h = $8().v;
    if (h == null) {
      return None;
    }
    final i = $9().v;
    if (i == null) {
      return None;
    }

    return Some((a, b, c, d, e, f, g, h, i));
  }
}

extension RecordFunctionToOption10<A, B, C, D, E, F, G, H, I, J> on (
  Option<A> Function(),
  Option<B> Function(),
  Option<C> Function(),
  Option<D> Function(),
  Option<E> Function(),
  Option<F> Function(),
  Option<G> Function(),
  Option<H> Function(),
  Option<I> Function(),
  Option<J> Function()
) {
  Option<(A, B, C, D, E, F, G, H, I, J)> toOption() {
    final a = $1().v;
    if (a == null) {
      return None;
    }
    final b = $2().v;
    if (b == null) {
      return None;
    }
    final c = $3().v;
    if (c == null) {
      return None;
    }
    final d = $4().v;
    if (d == null) {
      return None;
    }
    final e = $5().v;
    if (e == null) {
      return None;
    }
    final f = $6().v;
    if (f == null) {
      return None;
    }
    final g = $7().v;
    if (g == null) {
      return None;
    }
    final h = $8().v;
    if (h == null) {
      return None;
    }
    final i = $9().v;
    if (i == null) {
      return None;
    }
    final j = $10().v;
    if (j == null) {
      return None;
    }

    return Some((a, b, c, d, e, f, g, h, i, j));
  }
}
