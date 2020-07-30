package category.instances.functor

import org.scalatest.FlatSpec
import org.scalatest.Matchers
import category.Printable
import category.syntax.printable.PrintableSyntax._
import category.syntax.functor.ContravariantFunctorSyntax._
import category.instances.functor.ContravariantFunctorInstance._

class ContravariantFunctorInstanceTest extends FlatSpec with Matchers {

  case class Money(amount: Int)
  case class Salary(size: Money)

  "ContravariantFunctor" should "map printable" in {
    implicit val showMoney: Printable[Money]   = Printable.format(m => s"${m.amount}")
    implicit val showSalary: Printable[Salary] = showMoney.contramap(_.size)
    assert(Salary(Money(1000)).show == "1000")
    assert(Salary(Money(1000)).show != "10000")
  }

}
