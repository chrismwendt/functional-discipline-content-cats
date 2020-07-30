package com.yevhenii.products

object Coproducts {

  def i(n: Int): Int = n
  def j(b: Boolean): Int = if (b) 0 else 1

//  proof that Either is better than Int equipped with injections `i` and `j`
  def m(either: Either[Int, Boolean]): Int = either match {
    case Left(n) => n
    case Right(b) => if (b) 0 else 1
  }

  def `i'`(n: Int): Int =
    if (n < 0) n
    else n + 2

//  proof that Either is better than Int equipped with injections `i'` and `j`
  def `m'`(either: Either[Int, Boolean]): Int = either match {
    case Left(n) if n < 0 => n
    case Left(n) => n + 2
    case Right(b) => if (b) 0 else 1
  }
}
