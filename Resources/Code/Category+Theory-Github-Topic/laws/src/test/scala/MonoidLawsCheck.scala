import org.scalacheck._
import org.scalacheck.Properties
import org.scalacheck.Prop.forAll

import MonoidModule.Monoid
import MonoidModule.MonoidLaws
import MonoidModule.MonoidLawsNoSyntax
import MonoidModule.MonoidInstances._

sealed abstract class MonoidLawsCheck[A : Monoid](name: String)(
  implicit
    AA: Arbitrary[A]
) extends Properties(s"$name Monoid Laws Check") {

  val laws          = MonoidLaws[A]
  val lawsNoSyntax  = MonoidLawsNoSyntax[A]

  property(" Zero Identity") = forAll {
    (a: A) => laws.emptyIdentity(a)
  }

  property(" Combine Associativity") = forAll {
    (a1: A, a2: A, a3: A) => laws.combineAssociativity(a1, a2, a3)
  }

  property(" Zero Identity No Syntax") = forAll {
    (a: A) => lawsNoSyntax.emptyIdentity(a)
  }

  property(" Combine Associativity No Syntax") = forAll {
    (a1: A, a2: A, a3: A) => lawsNoSyntax.combineAssociativity(a1, a2, a3)
  }
}

object IntWithAddMonoidLawsCheck          extends MonoidLawsCheck[Int]("Int With Addition")
object StringWithConcatMonoidLawsCheck    extends MonoidLawsCheck[String]("String With Concatenation")
object ListOfIntWithConcatMonoidLawsCheck extends MonoidLawsCheck[List[Int]]("List Of Int With Concatenation")
