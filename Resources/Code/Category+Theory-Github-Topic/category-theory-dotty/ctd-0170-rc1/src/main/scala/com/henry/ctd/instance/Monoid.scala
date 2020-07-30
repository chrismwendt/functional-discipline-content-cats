package com.henry.ctd.instance

import com.henry.ctd.typeclass.Monoid

delegate StringMonoid for Monoid[String] {
  override def mempty = ""
  override def (m1: String) mappend (m2: String) = m1 + m2
}

delegate IntMonoid for Monoid[Int] {
  override def mempty = 0
  override def (m1: Int) mappend (m2: Int) = m1 + m2
}