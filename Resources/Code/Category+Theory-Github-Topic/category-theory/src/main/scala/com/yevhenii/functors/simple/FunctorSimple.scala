package com.yevhenii.functors.simple

trait Functor[+A] {
  def map[B](f: A => B): Functor[B]
}

trait Maybe[+A] extends Functor[A] {
  override def map[B](f: A => B): Functor[B] = this match {
    case MNothing => MNothing
    case Just(x) => Just(f(x))
  }
}

case object MNothing extends Maybe[Nothing]
case class Just[A](x: A) extends Maybe[A]