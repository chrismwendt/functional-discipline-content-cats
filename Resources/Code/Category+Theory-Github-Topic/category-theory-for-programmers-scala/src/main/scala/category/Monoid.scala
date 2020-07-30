package category

trait Monoid[A] {
  def empty: A

  def combine(a: A, b: A): A
}

object Monoid {
  def apply[A: Monoid]: Monoid[A] = implicitly[Monoid[A]]
}
