package com.henry.ctd.data

final case class Pair[+A, +B](a: A, b: B)

def fst[A](pair: Pair[A, ?]): A = pair match {
  case Pair(a, _) => a
}

def snd[B](pair: Pair[?, B]): B = pair match {
  case Pair(_, b) => b
}

def productFactorizer[A, B, C](p: C => A)(q: C => B)(x: C): Pair[A, B] = Pair(p(x), q(x))