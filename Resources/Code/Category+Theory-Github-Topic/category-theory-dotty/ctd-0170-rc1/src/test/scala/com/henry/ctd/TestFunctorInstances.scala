package com.henry.ctd

import org.junit.Test
import org.junit.Assert._

import com.henry.ctd.data.{ Option, None, Some }
import com.henry.ctd.data.{ List, Nil, Cons }
import com.henry.ctd.data.Reader
import delegate com.henry.ctd.instance.{ OptionCoFunctor, ListCoFunctor, ReaderCoFunctor }

class TestFunctorInstances {
  @Test def testOptionCoFunctor(): Unit = {
    val f: Int => String = _.toString
    assertEquals(Some(5).fmap(f), Some("5"))
    assertEquals(None.fmap(f), None)
  }

  @Test def testListCoFunctor(): Unit = {
    val f: Int => String = _.toString
    assertEquals(Cons(5, Cons(4, Nil)).fmap(f), Cons("5", Cons("4", Nil)))
    assertEquals(Nil.fmap(f), Nil)
  }

  @Test def testReaderCoFunctor(): Unit = {
    val f1: Int => Boolean = _ % 2 == 0
    val f2: Long => Boolean = _ % 2 == 0
    assertEquals(f1.fmap(_.toString)(4), "true")
    assertEquals(f1.fmap(_.toString)(5), "false")
    assertEquals(f2.fmap(_.toString)(4L), "true")
    assertEquals(f2.fmap(_.toString)(5L), "false")
  }
}