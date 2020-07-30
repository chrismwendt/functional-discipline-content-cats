package category.syntax.kleisli

import category.Kleisli

class KleisliSyntax {

  implicit class KleisliOps[F[_], A, B](a: Kleisli[F, A, B]) {
    def >=>[C](b: Kleisli[F, B, C])(
      implicit k: Kleisli[F, A, C]
    ): Kleisli[F, A, C] = k.compose(a, b)
  }

}
