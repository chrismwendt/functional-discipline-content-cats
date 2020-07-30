package category.syntax.printable

import category.Printable

object PrintableSyntax {
  implicit class PrintableOps[A](value: A) {
    def show(implicit p: Printable[A]): String = p.format(value)
  }
}
