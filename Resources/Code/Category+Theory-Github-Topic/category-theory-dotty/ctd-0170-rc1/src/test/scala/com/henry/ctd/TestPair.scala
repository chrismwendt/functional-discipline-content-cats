package com.henry.ctd

import org.junit.Test
import org.junit.Assert._

import com.henry.ctd.data.{ fst, snd, productFactorizer }
import com.henry.ctd.data.Pair

class TestPair {
  @Test def testFst(): Unit = {
    assertEquals(fst(Pair("Hello", 1)), "Hello")
    assertEquals(fst(Pair(1, true)), 1)
    assertEquals(fst(Pair(true, "Hello")), true)
  }

  @Test def testSnd(): Unit = {
    assertEquals(snd(Pair("Hello", 1)), 1)
    assertEquals(snd(Pair(1, true)), true)
    assertEquals(snd(Pair(true, "Hello")), "Hello")
  }

  @Test def testProductFactorizer(): Unit = {
    val intToStrAndBool = productFactorizer[C = Int](_.toString)(_ > 4)
    assertEquals(intToStrAndBool(3), Pair("3", false))
    assertEquals(intToStrAndBool(4), Pair("4", false))
    assertEquals(intToStrAndBool(5), Pair("5", true))
  }
}