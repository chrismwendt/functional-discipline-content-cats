package two

object Memoize {
  // Returns memoize function-object for any given function
  def apply[A, B](f1: A => B): Memoize[A, B] = new Memoize[A, B](f1)
}

class Memoize[A, B](private val f1: A => B) {
  // Validate given function should not be null
  require(f1 != null)

  // Map for store computed results
  private val results = scala.collection.mutable.Map.empty[A, B]

  def apply(arg: A): B = {
    results.get(arg) match {
      case Some(value) => value
      case None =>
        val tt = f1(arg)
        results += arg -> tt
        tt
    }
  }
}

