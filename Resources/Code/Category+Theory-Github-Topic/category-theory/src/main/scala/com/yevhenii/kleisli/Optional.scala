package com.yevhenii.kleisli

sealed trait Optional[+A] {
  def map[B](f: A => B): Optional[B] = this match {
    case None => None
    case Some(x) => Some(f(x))
  }

  def get: A = this match {
    case None => throw new RuntimeException
    case Some(x) => x
  }

  def isEmpty: Boolean = this match {
    case None => true
    case _ => false
  }
}

object Optional {
  def compose[A, B, C](f: B => Optional[C])(g: A => Optional[B]): A => Optional[C] =
    x => g(x) match {
      case None => None
      case Some(gx) => f(gx)
    }

  def id[A](x: Optional[A]): Optional[A] = x
}

case object None extends Optional[Nothing]

case class Some[A](value: A) extends Optional[A]
