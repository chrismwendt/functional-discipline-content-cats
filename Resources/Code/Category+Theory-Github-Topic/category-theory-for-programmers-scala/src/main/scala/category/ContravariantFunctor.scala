package category

trait ContravariantFunctor[F[_]] {
  def contramap[A, B](fa: F[A])(f: B => A): F[B]
}

object ContravariantFunctor {
  def apply[F[_]](implicit ev: ContravariantFunctor[F]): ContravariantFunctor[F] = ev
}
