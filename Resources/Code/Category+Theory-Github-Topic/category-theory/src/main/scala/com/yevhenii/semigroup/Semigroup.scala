package com.yevhenii.semigroup

trait Semigroup[A] {
  def combine(first: A, second: A): A
}

object Semigroup {
  def apply[S](implicit semigroup: Semigroup[S]): Semigroup[S] = semigroup
}

object SemogroupOps {
  implicit class SemigroupImplicitOps[A](first: A) {
    def combine(second: A)(implicit semigroup: Semigroup[A]): A = semigroup.combine(first, second)
  }

  implicit val intSemigroup: Semigroup[Int] = new Semigroup[Int] {
    override def combine(first: Int, second: Int): Int = first + second
  }

  implicit val stringSemigroup: Semigroup[String] = new Semigroup[String] {
    override def combine(first: String, second: String): String = first + second
  }

  class OptionSemigroup[A](implicit nested: Semigroup[A]) extends Semigroup[Option[A]] {
    override def combine(first: Option[A], second: Option[A]): Option[A] = (first, second) match {
      case (Some(x), Some(y)) => Some(nested.combine(x, y))
      case (a @ Some(_), None) => a
      case (None, b @ Some(_)) => b
      case _ => None
    }
  }

  implicit def optionSemigroup[A](implicit semigroup: Semigroup[A]): Semigroup[Option[A]] = new OptionSemigroup[A]

  implicit def listSemigroup[A]: Semigroup[List[A]] = new Semigroup[List[A]] {
    override def combine(first: List[A], second: List[A]): List[A] = first ++ second
  }
}

object Example {
  import SemogroupOps._

//  todo think about ways of dealing without factory methods
  def some[A](x: A): Option[A] = Some(x)
  def none[A]: Option[A] = None

  def main(args: Array[String]): Unit = {
    println(Semigroup[Int].combine(1, 2))
    println(Semigroup[Option[Int]].combine(Some(1), Some(2)))
    println(Semigroup[List[Int]].combine(List(1, 2), List(3, 4)))

    println(1.combine(2))
    println(some(1).combine(some(2)))
    println(List(1, 2).combine(List(3, 4)))
  }
}
