package one

object Challenge1 {

  // Identity function
  def myIdentity[T](arg: T): T = arg

  // Composition from A->B and B->C to A->C
  def compose[A, B, C](f1: A => B, f2: B => C): A => C = x => f2(f1(x))
}
