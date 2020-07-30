/**
 ** Maybe functor
 **/

export let Maybe = function(x) {
  this.__value = x
}

Maybe.of = function(x) {
  return new Maybe(x)
}

Maybe.prototype.isNothing = function() {
  return this.__value === null || this.__value === undefined
}
Maybe.prototype.map = function(f) {
  return this.isNothing() ? Maybe.of(null) : Maybe.of(f(this.__value))
}
Maybe.prototype.join = function() {
  return this.isNothing() ? Maybe.of(null) : this.__value
}
Maybe.prototype.chain = function(f) {
  return this.map(f).join()
}
Maybe.prototype.flatMap = Maybe.chain
Maybe.prototype.bind = Maybe.chain
Maybe.prototype.ap = function(other_maybe) {
  return other_maybe.map(this.__value)
}
