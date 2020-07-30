package com.yevhenii.categories.monoid

object MonoidAnd {

  val unit: MonoidAnd = MonoidAnd(true)

  def identity(x: MonoidAnd): MonoidAnd = unit.and(x)
}

case class MonoidAnd(state: Boolean) {

  def and(x: MonoidAnd): MonoidAnd = MonoidAnd(state && x.state)
}
