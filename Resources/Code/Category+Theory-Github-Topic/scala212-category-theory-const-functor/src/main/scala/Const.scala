/**
  * Created by mtumilowicz on 2019-02-05.
  */
final case class Const[C, A](param: C) {
  def map[B](f: A => B): Const[C, B] = this.asInstanceOf[Const[C, B]]
}
