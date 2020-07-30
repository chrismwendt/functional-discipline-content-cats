package category.instances.functor

import category.adt.Just
import org.scalatest.{ FlatSpec, Matchers }
import org.scalatestplus.scalacheck.ScalaCheckPropertyChecks
import category.instances.functor.FunctorInstance._
import category.syntax.functor.FunctorSyntax._

class FunctorInstanceTest extends FlatSpec with ScalaCheckPropertyChecks with Matchers {

  "Functor" should "follow identity law" in {
    forAll { str: String =>
      assert(Just(str).map(identity) == Just(str))
    }
  }

}
