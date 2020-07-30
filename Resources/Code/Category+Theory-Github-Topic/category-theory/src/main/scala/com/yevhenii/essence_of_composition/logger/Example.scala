package com.yevhenii.essence_of_composition.logger

object Example {

  def main(args: Array[String]): Unit = {

    val f = Writer(Functions.negate, "not")
    val g = Writer(Functions.identity, "id")

    val `g.f` = g.compose(f)

    val `f.g` = f.compose(g)

    val (res, msg) = `g.f`(true)
    val (resReverse, msgReverse) = `f.g`(true)

    println("g - identity; f - not operator")
    println(s"g after f: $msg; result = $res")
    println(s"f after g: $msgReverse; result = $resReverse")

    assert((resReverse, msgReverse) == g.composeReverse(f)(true))
    assert((res, msg) == f.composeReverse(g)(true))
  }
}
