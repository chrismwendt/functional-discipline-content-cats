package category.instances.printable
import category.Printable

object PrintableInstance {

  implicit val printableInstanceBoolean: Printable[Boolean] = new Printable[Boolean] {
    def format(a: Boolean): String = if (a) "Yes" else "No"
  }

  implicit val printableInstanceString: Printable[String] = new Printable[String] {
    def format(a: String): String = a
  }

}
