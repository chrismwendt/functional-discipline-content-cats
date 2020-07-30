package com.yevhenii.essence_of_composition.logger

case class Writer[A, B](f: (A) => B, msg: String) extends Function[A, (B, String)] {

  override def apply(x: A): (B, String) = {
    f(x) -> msg
  }

  def composeReverse[C](g: Writer[B ,C]): A => (C, String) = (x) => {
    val fRes = apply(x)
    val gRes = g(fRes._1)

    gRes._1 -> s"${fRes._2} => ${gRes._2}"
  }

  def compose[C](g: Writer[C, A]): C => (B, String) = (x) => {
    val gRes = g(x)
    val fRes: (B, String) = apply(gRes._1)

    fRes._1 -> s"${gRes._2} => ${fRes._2}"
  }


  def composeReverse[C](g: B => (C, String)): A => (C, String) = (x) => {
    val fRes = apply(x)
    val gRes = g(fRes._1)

    gRes._1 -> (fRes._2 + gRes._2)
  }

  def compose[C](g: C => (A, String)): C => (B, String) = (x) => {
    val gRes = g(x)
    val fRes: (B, String) = apply(gRes._1)

    fRes._1 -> (gRes._2 + fRes._2)
  }
}