package com.yevhenii.products

sealed trait Either[+L, +R]

case class Left[L](value: L) extends Either[L, Nothing]
case class Right[R](value: R) extends Either[Nothing, R]
