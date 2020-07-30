/**
  * Created by mtumilowicz on 2019-01-09.
  */
class BiFunctiorialEither[X, Y](val either: Either[X, Y]) {

  def bimap[X1, Y1](first: X => X1, second: Y => Y1): Either[X1, Y1] = either match {
    case Left(x) => Left(first(x))
    case Right(y) => Right(second(y))
  }

  def first[X1](f: Function[X, X1]): Either[X1, Y] = bimap(f, identity)

  def second[Y1](f: Function[Y, Y1]): Either[X, Y1] = bimap(identity, f)
  
}
