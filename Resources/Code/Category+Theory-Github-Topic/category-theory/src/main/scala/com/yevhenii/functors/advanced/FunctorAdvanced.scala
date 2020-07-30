package com.yevhenii.functors.advanced

import scala.language.higherKinds

// idea taken from:
// https://github.com/HowProgrammingWorks/Functor/blob/master/Scala/Advanced/

// todo resolve variance issue
trait Functor[F[_]] {
  def fmap[A, B](fa: F[A])(f: A => B): F[B]
}

object Functor {
  def apply[F[_]](implicit f: Functor[F]): Functor[F] = f
}

sealed trait Maybe[+A]

case object MNothing extends Maybe[Nothing]
case class Just[A](x: A) extends Maybe[A]

object Maybe {
  def just[A](x: A): Maybe[A] = Just(x)

  def nothing[A]: Maybe[A] = MNothing

  implicit val maybeFunctor: Functor[Maybe] = new Functor[Maybe] {
    override def fmap[A, B](fa: Maybe[A])(f: A => B): Maybe[B] = fa match {
      case MNothing => MNothing
      case Just(x) => Just(f(x))
    }
  }
}

object FunctorOps {
  implicit class ImplicitFunctorOps[F[_], A](fa: F[A]) {
    def fmap[B](f: A => B)(implicit functor: Functor[F]): F[B] = {
      functor.fmap(fa)(f)
    }
  }
}

object Example {
  import FunctorOps._
  import Maybe._

  def main(args: Array[String]): Unit = {
    println(Functor[Maybe].fmap(Just(2))(_ * 5))
    println(Functor[Maybe].fmap(MNothing)((a: Int) => a * 5))

    println(just(2).fmap(_ * 5))
  }
}