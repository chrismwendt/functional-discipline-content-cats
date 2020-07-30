package category.instances.printable
import org.scalatest.FlatSpec
import org.scalatest.Matchers
import category.syntax.printable.PrintableSyntax._
import category.instances.printable.PrintableInstance._

class PrintableInstanceTest extends FlatSpec with Matchers {

  "Printable" should "print boolean value in string" in {
    assert(true.show == "Yes")
    assert(false.show == "No")
    assert(true.show != "No")
    assert(false.show != "Yes")
  }

  "Printable" should "print string value in string" in {
    assert("test".show == "test")
    assert("test".show != "test1")
  }
}
