package category.instances.functor

import org.scalatest.FlatSpec
import category.instances.functor.BiFunctorInstance._
import category.syntax.functor.BiFunctorSyntax._

class BiFunctorInstanceTest extends FlatSpec {
  private val tuple: (Int, Int) = (1, 2).bimap(v => v + 1, v => v * 2)
  "A BiFunctorInstance" should "map tuple" in {
    assert(tuple.equals((2, 4)))
  }

}
