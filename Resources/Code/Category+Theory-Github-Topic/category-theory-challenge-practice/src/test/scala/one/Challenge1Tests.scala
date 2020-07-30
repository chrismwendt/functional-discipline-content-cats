package one

import org.scalatest.FunSuite

class Challenge1Tests extends FunSuite {
  test("My identity should return its argument back") {
    assert(Challenge1.myIdentity(10) == 10)
    assert(Challenge1.myIdentity("Suraj") == "Suraj")
    assert(Challenge1.myIdentity(true))
    assert(Challenge1.myIdentity(12.34) == 12.34)
  }

  test("Simple compose test with two functions") {
    // Arrange
    val f1 = (x: Int) => if (x > 10) true else false
    val f2 = (x: Boolean) => if (x) "Suraj" else "Gharat"

    // Act
    val f3 = Challenge1.compose(f1, f2)

    // Assure
    assert(f3(50) == "Suraj")
    assert(f3(5) == "Gharat")
  }

  test("Compose with identity1") {
    // Arrange
    val f1 = (x: Int) => if (x > 10) true else false

    // Act
    val f4 = Challenge1.compose(Challenge1.myIdentity[Int], f1)

    // Assure
    assert(f4(100))
    assert(!f4(1))
  }

  test("Compose with identity2") {
    // Arrange
    val f1 = (x: Int) => if (x > 10) true else false

    // Act
    val f4 = Challenge1.compose(f1, Challenge1.myIdentity[Boolean])

    // Assure
    assert(f4(100))
    assert(!f4(1))
  }
}
