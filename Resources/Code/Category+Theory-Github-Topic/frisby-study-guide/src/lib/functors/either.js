/**
 ** Either functor
 **/
export const Left = function(x) {
  this.__value = x
}

export const Right = function(x) {
  this.__value = x
}

Left.prototype.map = function(f) {
  return this
}

Right.of = function(x) {
  return new Right(x)
}

Right.prototype.map = function(f) {
  return Right.of(f(this.__value))
}
