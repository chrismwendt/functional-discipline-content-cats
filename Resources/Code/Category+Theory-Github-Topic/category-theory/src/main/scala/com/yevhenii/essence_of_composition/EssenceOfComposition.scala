package com.yevhenii.essence_of_composition

object EssenceOfComposition {
  def identity[A]: A => A = {
    x => x
  }

  def compose[A, B, C](g: B => C)(f: A => B): A => C = {
    x => g(f(x))
  }

  def main(args: Array[String]): Unit = {
    assert(identity(123) == 123)
    println(identity(123))

    val f: Int => Double = x => x + 2.0
    val g: Double => Double = x => x * x
    val h: Double => String = x => s"${x * 2}"

    val composed: Int => Double = g.compose(f)
    val `g.f`: Int => Double = compose(g)(f)   // g after f

    assert(`g.f`(2) == 16.0)
    assert(composed(2) == 16.0)
    println(`g.f`(2))


    val `h.(g.f)` = h.compose(`g.f`)
    val `(h.g).f` = h.compose(g).compose(f)

    assert(`h.(g.f)`(2) == `(h.g).f`(2))

    val `id(x).f`: Int => Double = f.compose(identity)
    val `f.id(x)`: Int => Double = identity.compose(f)

    assert {
      f(2) == `id(x).f`(2) &&
        f(2) == `f.id(x)`(2)
    }
  }
}
