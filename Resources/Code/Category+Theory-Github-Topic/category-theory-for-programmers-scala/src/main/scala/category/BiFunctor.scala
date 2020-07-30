package category

trait BiFunctor[F[_, _]] {
  type id[A] = A

  def bimap[A, B, C, D](fab: F[A, B])(f: A => C, g: B => D): F[C, D]

  def first[A, B, C](fab: F[A, B])(g: A => C): F[C, B] = bimap(fab)(g, identity[B])

  def second[A, B, D](fab: F[A, B])(h: B => D): F[A, D] = bimap(fab)(identity[A], h)
}
