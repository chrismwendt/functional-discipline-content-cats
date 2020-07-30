package com.yevhenii.categories.monoid

object MonoidOr {

  def unit: MonoidOr = MonoidOr(false)

  def identity(x: MonoidOr): MonoidOr = x.or(unit)
}

case class MonoidOr(state: Boolean) {

  def or(x: MonoidOr): MonoidOr = MonoidOr(state || x.state)
}
