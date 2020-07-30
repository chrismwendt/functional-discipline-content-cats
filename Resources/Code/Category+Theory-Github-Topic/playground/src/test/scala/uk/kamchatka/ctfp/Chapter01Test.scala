package uk.kamchatka.ctfp

import org.scalatest.FunSpec
import org.scalatest.prop.PropertyChecks

class Chapter01Test extends FunSpec with PropertyChecks {
  def compose[A, B, C]: (A => B) => (B => C) => A => C = Chapter01.compose[A, B, C]

  def id[A]: A => A = Chapter01.identity[A]

  // 3. Write a program that tries to test that your composition function respects identity
  describe("compose") {
    it("should respect identity") {
      forAll { (a: Long, f: Long => Double) =>
        assert(compose(id[Long])(f)(a) === f(a))
        assert(compose(f)(id)(a) === f(a))
      }
    }
  }
}
