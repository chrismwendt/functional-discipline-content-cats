import R from 'ramda'

const dot = R.curry(function(prop, obj) {
  return obj[prop]
})

module.exports = {
  dot: dot
}
