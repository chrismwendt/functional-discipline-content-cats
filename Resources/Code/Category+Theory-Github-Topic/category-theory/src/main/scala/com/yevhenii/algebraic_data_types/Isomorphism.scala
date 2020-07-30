package com.yevhenii.algebraic_data_types

sealed trait Maybe[+A]

case object MNothing extends Maybe[Nothing]
case class Just[A](value: A) extends Maybe[A]


sealed trait Either[+L, +R]

case class Left[L](left: L) extends Either[L, Nothing]
case class Right[R](right: R) extends Either[Nothing, R]


object Isomorphism {
  def maybeToUnitEither[A](maybe: Maybe[A]): Either[Unit, A] = maybe match {
    case MNothing => Left(())
    case Just(x) => Right(x)
  }
}
