package category.syntax.functor

import category.BiFunctor

object BiFunctorSyntax {

  implicit class BiFunctorOps[F[_, _], A, B](a: F[A, B]) {
    def bimap[C, D](g: A => C, h: B => D)(implicit F: BiFunctor[F]): F[C, D] = F.bimap(a)(g, h)
  }
}
