package com.yevhenii.functoriality

import scala.languageFeature.higherKinds


trait Bifunctor[F[_, _]] {
  def bimap[A, B, C, D](fab: F[A, B])(f: A => C)(g: B => D): F[C, D]
  def first[A, B, C](fab: F[A, B])(f: A => C): F[C, B]
  def second[A, B, D](fab: F[A, B])(g: B => D): F[A, D]
}

object BifunctorOps {
  implicit class BifunctorImplicitOps[F[_, _], A, B](pair: F[A, B]) {
    def bimap[C, D](f: A => C)(g: B => D)(implicit functor: Bifunctor[F]): F[C, D] = {
      functor.bimap(pair)(f)(g)
    }

    def first[C](f: A => C)(implicit functor: Bifunctor[F]): F[C, B] = {
      functor.first(pair)(f)
    }

    def second[D](g: B => D)(implicit functor: Bifunctor[F]): F[A, D] = {
      functor.second(pair)(g)
    }
  }
}

case class Pair[A, B](left: A, right: B)

object Pair {
  implicit val pairBifunctor = new Bifunctor[Pair] {
    override def bimap[A, B, C, D](fab: Pair[A, B])(f: A => C)(g: B => D): Pair[C, D] = {
      Pair(f(fab.left), g(fab.right))
    }

    override def first[A, B, C](fab: Pair[A, B])(f: A => C): Pair[C, B] = {
      Pair(f(fab.left), fab.right)
    }

    override def second[A, B, D](fab: Pair[A, B])(g: B => D): Pair[A, D] = {
      Pair(fab.left, g(fab.right))
    }
  }
}

object Example {
  import Pair._
  import BifunctorOps._

  def main(args: Array[String]): Unit = {
    println(Pair(1, 2).bimap(_ + 10)(_ * 2).first(_ - 2).second(_ + 1))
  }
}