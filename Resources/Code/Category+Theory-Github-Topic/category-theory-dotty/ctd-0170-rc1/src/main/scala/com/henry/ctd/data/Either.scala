package com.henry.ctd.data

sealed trait Either[+A, +B]
final case class Left[A](a: A) extends Either[A, Nothing]
final case class Right[B](b: B) extends Either[Nothing, B]

def asLeft[A](a: A): Either[A, ?] = Left(a)

def asRight[B](b: B): Either[?, B] = Right(b)

def coproductFactorizer[A, B, C](i: A => C)(j: B => C)(either: Either[A, B]): C = either match {
  case Left(a) => i(a)
  case Right(b) => j(b)
}