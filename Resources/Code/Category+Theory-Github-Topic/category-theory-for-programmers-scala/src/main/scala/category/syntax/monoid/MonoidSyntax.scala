package category.syntax.monoid

import category.Monoid

object MonoidSyntax {

  implicit class MonoidOps[A](a: A) {
    def |+|(b: A)(implicit m: Monoid[A]): A = m.combine(a, b)
  }

}
