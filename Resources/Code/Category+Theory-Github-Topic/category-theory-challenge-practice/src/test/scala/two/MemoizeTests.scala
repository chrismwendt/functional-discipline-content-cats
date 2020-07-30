package two

import org.scalatest.FunSuite

class MemoizeTests extends FunSuite{
  test("Memoize of simple square function"){
    // arrange
    val f1 = (x:Int) =>{
      println("Calculating square of "+x)
      x * x
    }

    // Act
    val m = Memoize(f1)
    val result1 = m(10)
    val result2 = m(10)
    val result3 = m(20)

    assert(result1==100)
    assert(result2==100)
    assert(result3==400)
  }

  test("Memoiz of long running function"){
    // arrange
    val f1 = (x:Long) => (1l to x).foldLeft[BigInt](0)((x,y)=> x+y)

    // Act
    val m = Memoize(f1)
    val r1 = m(1000000)
    val r2 = m(1000000)
    val r3 = m(1000000)

    // Assure
    assert(r1==r2)
    assert(r2==r3)
  }

  test("Memoize library function"){
    // Arrange
    val f1: Int => Int = (x:Int) => new scala.util.Random().nextInt(x)

    // Act
    val m = Memoize(f1)
    val r1 = m(100)
    val r2 = m(100)

    // Assure
    assert(r1==r2)
  }
}
