package category

trait Printable[A] {
  def format(a: A): String
}

object Printable {
  def apply[A](implicit ev: Printable[A]): Printable[A] = ev

  def format[A](f: A => String): Printable[A] = new Printable[A] {
    def format(a: A): String = f(a)
  }
}
