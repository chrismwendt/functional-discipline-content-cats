package category.adt

sealed trait Maybe[+A]

case class Just[A](value: A) extends Maybe[A]

object Empty extends Maybe[Nothing]

object Maybe {
  def apply[A](a: A): Maybe[A] = if (a == null) Empty else Just(a)
}

object Just {
  def apply[A](value: A): Maybe[A] = new Just(value)
}
