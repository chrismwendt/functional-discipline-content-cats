package com.henry.ctd

import org.junit.Test
import org.junit.Assert._

import com.henry.ctd.data.{ asLeft, asRight, coproductFactorizer }
import com.henry.ctd.data.{ Either, Left, Right }

class TestEither {
  @Test def testAsLeft(): Unit = {
    assertEquals(asLeft(5), Left(5): Either[Int, String])
    assertEquals(asLeft(5), Left(5): Either[Int, Boolean])
    assertEquals(asLeft("Hello"), Left("Hello"): Either[String, Int])
    assertEquals(asLeft("Hello"), Left("Hello"): Either[String, Boolean])
  }

  @Test def testAsRight(): Unit = {
    assertEquals(asRight(5), Right(5): Either[String, Int])
    assertEquals(asRight(5), Right(5): Either[Boolean, Int])
    assertEquals(asRight("Hello"), Right("Hello"): Either[Int, String])
    assertEquals(asRight("Hello"), Right("Hello"): Either[Boolean, String])
  }

  @Test def testCoproductFactorizer(): Unit = {
    val intOrStrToBool = coproductFactorizer[A = Int, B = String](_ > 4)(_.isEmpty)
    assertEquals(intOrStrToBool(Left(3)), false)
    assertEquals(intOrStrToBool(Left(5)), true)
    assertEquals(intOrStrToBool(Right("")), true)
    assertEquals(intOrStrToBool(Right("Hello")), false)
  }
}