package com.henry.ctd.typeclass

trait CoFunctor[F[_]] {
  def (fa: F[A]) fmap[A, B](f: A => B): F[B]
}