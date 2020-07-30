package com.yevhenii.algebraic_data_types

sealed trait Shape {
  val area: Double = this match {
    case Circle(r) => math.Pi * r * r
    case Rect(d, h) => d * h
    case Square(a) => a * a
  }

  val circ: Double = this match {
    case Circle(r) => math.Pi * r * 2
    case Rect(d, h) => 2 * (d + h)
    case Square(a) => 2 * (a + a)
  }
}

case class Circle(r: Double) extends Shape
case class Rect(d: Double, h: Double) extends Shape
case class Square(a: Double) extends Shape
