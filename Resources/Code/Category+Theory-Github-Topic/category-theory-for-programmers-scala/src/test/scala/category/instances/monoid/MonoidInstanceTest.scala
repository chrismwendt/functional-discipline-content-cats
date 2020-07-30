package category.instances.monoid

import category.Monoid
import category.instances.monid.MonoidInstance._
import category.syntax.monoid.MonoidSyntax._
import org.scalatest.{ FlatSpec, Matchers }
import org.scalatestplus.scalacheck.ScalaCheckPropertyChecks

class MonoidInstanceTest extends FlatSpec with ScalaCheckPropertyChecks with Matchers {

  "Monoid" should "follow identity law" in {
    forAll { str: String =>
      assert((str |+| Monoid[String].empty) == str)
      assert((Monoid[String].empty |+| str) == str)
    }
  }

  it should "follow associative law" in {
    forAll { (s1: String, s2: String, s3: String) =>
      (s1 |+| s2) |+| s3 should be(s1 |+| (s2 |+| s3))
    }
  }
}
