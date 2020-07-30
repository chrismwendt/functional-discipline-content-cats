package com.yevhenii.kleisli

object SafeMath {

  def safeRoot(x: Double): Optional[Double] =
    if (x >= 0) Some(math.sqrt(x))
    else None

  def safeReciprocal(x: Double): Optional[Double] =
    if (x == 0) None
    else Some(1 / x)

  def safeRootReciprocal: Double => Optional[Double] = {
    Optional.compose(safeRoot)(safeReciprocal)
  }


  def main(args: Array[String]): Unit = {
    println(safeRootReciprocal(0))
    println(safeRootReciprocal(-4))
    println(safeRootReciprocal(4))
  }
}
