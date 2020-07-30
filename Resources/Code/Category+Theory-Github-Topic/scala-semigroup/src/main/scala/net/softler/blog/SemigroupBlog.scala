package net.softler.blog

trait Semigroup[A] {
  def append(a: A, b: A): A
}
object Groups {
  implicit object IntGroup extends Semigroup[Int] {
    override def append(a: Int, b: Int): Int = a + b
  }

  implicit object StringGroup extends Semigroup[String] {
    override def append(a: String, b: String): String = a + b
  }

  implicit object DoubleGroup extends Semigroup[Double] {
    override def append(a: Double, b: Double): Double = a + b
  }

  implicit object CarGroup extends Semigroup[Car] {
    override def append(a: Car, b: Car): Car = Car(a.horsePower + b.horsePower)
  }
}

case class Car(horsePower: Int)

/**
  * Shows the usage of the scala semi group
  * This is only a example
  */
object SemigroupBlog extends App {

  import Groups._

  def calculate[A](input: A)(implicit semigroup: Semigroup[A]): A =
    semigroup.append(input, input)

  def reduce[A](input: List[A])(implicit semigroup: Semigroup[A]): A =
    input.reduce(semigroup.append)

  println(calculate(100d))

  println(reduce(List(1, 2, 3, 4, 5)))

  println(calculate(Car(150)))

  println(reduce(List(Car(20), Car(50), Car(111))))
}
