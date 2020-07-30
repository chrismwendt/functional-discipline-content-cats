package category.instances.functor
import category.Printable
import category.ContravariantFunctor

object ContravariantFunctorInstance {
  implicit val contravariantFunctorPrintableInstance: ContravariantFunctor[Printable] =
    new ContravariantFunctor[Printable] {
      def contramap[A, B](fa: Printable[A])(f: B => A): Printable[B] = new Printable[B] {
        def format(a: B): String = fa.format(f(a))
      }
    }
}
