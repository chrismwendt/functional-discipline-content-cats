import org.scalatest.{FunSuite, Matchers}

/**
  * Created by mtumilowicz on 2019-01-09.
  */
class BiFunctiorialEitherTest extends FunSuite with Matchers {

  implicit def toBiFunctorialEither[X, Y](either: Either[X, Y]) = new BiFunctiorialEither(either)

  test("bimap test") {
    Right[Int, String]("a").bimap(_ * 2, _ + " mapped") should be(Right("a mapped"))
    Left[Int, String](1).bimap(_ * 2, _ + " mapped") should be(Left(2))
  }

  test("function first - derived from bimap") {
    def f(i: Int) = i * 2
    
    Left[Int, String](1).first(f) should be(Left(2))
  }

  test("function second - derived from bimap") {
    def f(s: String) = s + " mapped"
    
    Right[Int, String]("a").second(f) should be(Right("a mapped"))
  }

}
