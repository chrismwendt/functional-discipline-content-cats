package com.yevhenii.functors.simple

trait FunctorF[A, B] {
  def map[C](f: B => C): FunctorF[A, C]
}

case class Reader[A, B](log: String, f: A => B) extends FunctorF[A, B] {
  def apply(x: A): (B, String) = f(x) -> log

  def andThen[C](g: Reader[B, C]): Reader[A, C] =
    Reader(
      composeLog(log, g.log),
      f andThen g.f
    )

  def compose[C](g: Reader[C, A]): Reader[C, B] =
    Reader(
      composeLog(g.log, log),
      f compose g.f
    )

  override def map[C](g: B => C): Reader[A, C] =
    Reader(log, g compose f)

  private def composeLog(log1: String, log2: String): String = s"$log1 -> $log2"
}


object Example {

  def main(args: Array[String]): Unit = {
    val id: Reader[Int, Int] = Reader("id", x => x)
    val multBy2: Reader[Int, Int] = Reader("multBy2", x => x * 2)

    println((id andThen multBy2)(2)._2)
  }
}