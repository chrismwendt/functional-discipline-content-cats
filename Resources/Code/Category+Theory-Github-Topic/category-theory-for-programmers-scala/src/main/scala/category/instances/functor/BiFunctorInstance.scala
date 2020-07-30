package category.instances.functor

import category.BiFunctor

object BiFunctorInstance {

  implicit val tuple2BiFunctorInstance: BiFunctor[Tuple2] = new BiFunctor[Tuple2] {
    override def bimap[A, B, C, D](fab: (A, B))(f: A => C, g: B => D): (C, D) = (f(fab._1), g(fab._2))
  }

}
