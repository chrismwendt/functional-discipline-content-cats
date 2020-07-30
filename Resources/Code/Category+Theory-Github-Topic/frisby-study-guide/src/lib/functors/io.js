/**
 ** IO monads
 **/
import R from 'ramda'

export const IO = function(f) {
  this.unsafePerformIO = f
}
/**
 ** think of IO as containing the return value of the wrapped action
 **/
IO.of = function(f) {
  return new IO(function() {
    return f
  })
}

IO.prototype.map = function(f) {
  return IO.of(R.compose(f, this.unsafePerformIO))
}

IO.prototype.join = function() {
  const thiz = this
  return new IO(function() {
    return thiz.unsafePerformIO() //.unsafePerformIO()
  })
}
IO.prototype.chain = function(f) {
  return this.map(f).join()
}
