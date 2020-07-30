package category.instances.monid

import category.Monoid

object MonoidInstance {

  implicit val monoidInstance: Monoid[String] = new Monoid[String] {
    override def empty: String = ""

    override def combine(a: String, b: String): String = a ++ b
  }
}
