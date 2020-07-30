package com.henry.ctd.typeclass

trait Monoid[M] {
  def mempty: M
  def (m1: M) mappend (m2: M): M
}