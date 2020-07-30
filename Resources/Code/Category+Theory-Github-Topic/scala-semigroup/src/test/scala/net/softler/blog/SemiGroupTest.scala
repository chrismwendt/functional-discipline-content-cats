package net.softler.blog

import org.scalatest.{Assertion, FlatSpec, Matchers}

/**
  * The tests to the semi group assumption
  */
class SemiGroupTest extends FlatSpec with Matchers {

  import Groups._

  "The scala semi group associative law" should "respect int's" in withSemiGroup(150) { group =>
    group.append(7, 3) shouldBe 10
  }

  it should "respect strings" in withSemiGroup("Test") { group =>
    group.append("Hallo", " Welt") shouldBe "Hallo Welt"
  }

  it should "respect doubles" in withSemiGroup(100.0) { group =>
    group.append(12.0, -1.5) shouldBe 10.5
  }

  it should "respect objects" in withSemiGroup(Car(115)) { group =>
    group.append(Car(122), Car(150)) shouldBe Car(272)
  }

  def withSemiGroup[A](value: A)(assertion: Semigroup[A] => Assertion)(
      implicit sg: Semigroup[A]): Assertion = {
    associativity(value, value, value) shouldBe true
    assertion(sg)
  }

  private def associativity[A](a1: A, a2: A, a3: A)(implicit sg: Semigroup[A]): Boolean =
    sg.append(a1, sg.append(a2, a3)) == sg.append(sg.append(a1, a2), a3)
}
