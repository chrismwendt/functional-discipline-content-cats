/**
  * Created by mtumilowicz on 2019-02-03.
  */
object TerminalObjects {
  def absurd[A]: Nothing => A = _ => ???
  def unit[A](a: A): Unit = ()
}
