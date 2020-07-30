package com.henry.ctd

import org.junit.Test
import org.junit.Assert._

import com.henry.ctd.typeclass.Monoid
import delegate com.henry.ctd.instance.{ StringMonoid, IntMonoid }

class TestMonoidInstances {
  @Test def testStringMonoid(): Unit = {
    assertEquals("Hello," mappend " world!", "Hello, world!")
    assertEquals("Hello" mappend the[Monoid[String]].mempty, "Hello")
  }

  @Test def testIntMonoid(): Unit = {
    assertEquals(3 mappend 8, 11)
    assertEquals(3 mappend the[Monoid[Int]].mempty, 3)
  }
}