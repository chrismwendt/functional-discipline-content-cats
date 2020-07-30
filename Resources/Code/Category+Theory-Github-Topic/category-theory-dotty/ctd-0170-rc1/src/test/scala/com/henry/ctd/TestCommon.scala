package com.henry.ctd

import org.junit.Test
import org.junit.Assert._

import com.henry.ctd.common._

class TestCommon {
  @Test def testIdentity(): Unit = {
    assertEquals(identity(1), 1)
    assertEquals(identity(false), false)
    assertEquals(identity("Hello"), "Hello")
  }

  @Test def testUnit(): Unit = {
    assertEquals(unit(1), ())
    assertEquals(unit(false), ())
    assertEquals(unit("Hello"), ())
  }

  @Test def testYes(): Unit = {
    assertEquals(yes(1), true)
    assertEquals(yes(false), true)
    assertEquals(yes("Hello"), true)
  }

  @Test def testNo(): Unit = {
    assertEquals(no(1), false)
    assertEquals(no(false), false)
    assertEquals(no("Hello"), false)
  }
}