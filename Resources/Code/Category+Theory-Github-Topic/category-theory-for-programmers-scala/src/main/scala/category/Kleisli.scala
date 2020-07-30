package category

trait Kleisli[F[_], A, C] {
  def compose[B](a: Kleisli[F, A, B], b: Kleisli[F, B, C]): Kleisli[F, A, C]
}

object Kleisli {
  def apply[F[_], A, C](implicit ev: Kleisli[F, A, C]): Kleisli[F, A, C] = ev
}
