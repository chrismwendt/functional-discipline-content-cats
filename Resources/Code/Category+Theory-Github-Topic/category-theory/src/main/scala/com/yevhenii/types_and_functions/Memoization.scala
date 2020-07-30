package com.yevhenii.types_and_functions

import scala.collection.mutable
import scala.util.Random

object Memoization {

  def memoize[A, B](f: A => B): A => B = {
    val states = new mutable.HashMap[A, B]()

    (x) => states.getOrElseUpdate(x, f(x))
  }

  def main(args: Array[String]): Unit = {
    val r = new Random()
    val randomMemoized = memoize(r.nextInt)

    for (_ <- 1 to 10) {
      println(randomMemoized(100))
    }

    val smartMemoize = memoize { (seedAndNum: (Int, Int)) =>
      val r = new Random(seedAndNum._1)
      r.nextInt(seedAndNum._2)
    }

    println(smartMemoize((10, 100)))
    println(smartMemoize((12, 100)))
    println(smartMemoize((10, 100)))
  }
}
