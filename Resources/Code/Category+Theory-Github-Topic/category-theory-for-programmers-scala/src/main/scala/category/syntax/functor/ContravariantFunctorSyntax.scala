package category.syntax.functor

import category.ContravariantFunctor

object ContravariantFunctorSyntax {
  implicit class ContravariantFunctorOps[F[_], A](fa: F[A]) {
    def contramap[B](f: B => A)(implicit F: ContravariantFunctor[F]): F[B] = F.contramap(fa)(f)
  }
}
