import org.scalatest.{FunSuite, Matchers}

/**
  * Created by mtumilowicz on 2019-02-05.
  */
class ConstTest extends FunSuite with Matchers {

  test("creation") {
    val const1: Const[Int, String] = Const(1)
    val const2: Const[Int, Object] = Const(1)

    const1.param should be(1)
    const2.param should be(1)
  }

  test("equals: same values, different dropped types") {
    val const1: Const[Int, String] = Const(1)
    val const2: Const[Int, Object] = Const(1)

    const1 should be(const2)
  }

  test("equals: different values") {
    val const1: Const[Int, String] = Const(1)
    val const2: Const[Int, String] = Const(2)

    const1 should not be const2
  }

  test("map") {
    val const: Const[Int, Int] = Const(1)


    val mapped: Const[Int, String] = const.map(_ => "a")
    mapped.param should be(1)
  }

}
