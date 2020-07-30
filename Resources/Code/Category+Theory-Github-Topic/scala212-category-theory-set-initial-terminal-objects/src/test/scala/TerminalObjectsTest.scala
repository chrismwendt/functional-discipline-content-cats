import org.scalatest.{FunSuite, Matchers}

/**
  * Created by mtumilowicz on 2019-02-03.
  */
class TerminalObjectsTest extends FunSuite with Matchers {
  
  test("absurd function exists") {
    val obj = TerminalObjects
    obj.absurd[Int] should not be null
  }

  test("single unit function") {
    val obj = TerminalObjects
    obj.unit(1) should be (obj.unit(2))
  }

}
