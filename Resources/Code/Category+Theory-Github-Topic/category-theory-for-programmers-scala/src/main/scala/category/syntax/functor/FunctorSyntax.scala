package category.syntax.functor

import category.Functor

object FunctorSyntax {

  implicit class FunctorOps[F[_], A](a: F[A]) {
    def map[B](b: A => B)(implicit F: Functor[F]): F[B] = F.map(a)(b)
  }

}
