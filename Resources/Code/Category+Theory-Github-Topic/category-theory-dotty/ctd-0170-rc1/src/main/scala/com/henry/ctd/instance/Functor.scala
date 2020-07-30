package com.henry.ctd.instance

import com.henry.ctd.data.{ Option, None, Some }
import com.henry.ctd.data.{ List, Nil, Cons }
import com.henry.ctd.data.Reader
import com.henry.ctd.typeclass.CoFunctor

delegate OptionCoFunctor for CoFunctor[Option] {
  def (fa: Option[A]) fmap[A, B](f: A => B): Option[B] = {
    fa match {
      case None => None
      case Some(x) => Some(f(x))
    }
  }
}

delegate ListCoFunctor for CoFunctor[List] {
  def (fa: List[A]) fmap[A, B](f: A => B): List[B] = {
    fa match {
      case Nil => Nil
      case Cons(h, t) => Cons(f(h), t fmap f)
    }
  }
}

delegate ReaderCoFunctor[R] for CoFunctor[Reader[R]] {
  def (fa: Reader[R][A]) fmap[A, B](f: A => B): Reader[R][B] = f.compose(fa)
}