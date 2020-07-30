/**
 ** Maybe functor specifications
 **/
import R from 'ramda'
import test from 'ava'
import { Maybe } from '../../../src/lib/functors/Maybe'
import utils from '../../../src/lib/utils'

const add = x => y => x + y
const add10 = add(10)

/**
 ** helper functions from "Maybe" chapter
 **/
Maybe.of = function(x) {
  return new Maybe(x)
}
const log = R.bind(console.log, console) // debugging ramda composiotn
const safeHead = xs => Maybe.of(xs[0])
const safeDot = R.curry(function(prop, obj) {
  return Maybe.of(utils.dot(prop, obj))
})

const map = R.curry(function(f, x) {
  return x.map(f)
})
const chain = R.curry(function(f, m) {
  return m.map(f).join()
})

const maybeStreetName = R.compose(
  chain(safeDot('street')),
  R.tap(log),
  chain(safeHead),
  safeDot('address')
)

const streetName = R.compose(
  map(utils.dot('street')),
  R.tap(log),
  safeHead,
  utils.dot('address')
)

const arrayOne = R.compose(chain(safeDot('a')), R.tap(log), safeHead)
test('map over non null Maybe functor', t => {
  t.deepEqual(Maybe.of(14).map(add10), Maybe.of(24))
})

test('map over null Maybe functor', t => {
  t.deepEqual(Maybe.of(null).map(add10), Maybe.of(null))
})
test('map is the same as Maybe.map', t => {
  t.deepEqual(Maybe.of(14).map(add10), map(add10)(Maybe.of(14)))
})
test('map over safeHead when not null', t => {
  t.deepEqual(
    streetName({ address: [{ street: 'Shady Ln', number: 4201 }] }),
    Maybe.of('Shady Ln')
  )
})
test('chain over safeHead when not null', t => {
  t.deepEqual(
    maybeStreetName({ address: [{ street: 'Shady Ln', number: 4201 }] }),
    Maybe.of('Shady Ln')
  )
})
test('map over safeHead when null', t => {
  t.truthy(
    streetName({ address: [] }).isNothing(),
    "no street name was given. should've been undefined!"
  )
})

test('chain over safeHead when null', t => {
  t.truthy(
    maybeStreetName({ address: [] }).isNothing(),
    "no street name was given. should've been undefined!"
  )
})
test('safeHead chain specifications', t => {
  const computed = arrayOne([{ a: 1 }, { a: 2 }])
  t.deepEqual(computed, Maybe.of(1))
})
test('safeDot null specifications', t => {
  t.truthy(safeDot('a')({}).isNothing())
})
test('safeDot some specifications', t => {
  console.log(`safedot = ${JSON.stringify(safeDot('a')({ a: 1 }))}`)
  t.deepEqual(safeDot('a')({ a: 1 }), Maybe.of(1))
})
test('applicative functor specifications', t => {
  let computed = Maybe.of(add(2)).ap(Maybe.of(3))
  t.deepEqual(computed, Maybe.of(5))
})
test('applicative functor map specifications', t => {
  let computationWithMap = Maybe.of(2)
    .map(add)
    .ap(Maybe.of(3))
  let computation = Maybe.of(add(2)).ap(Maybe.of(3))
  t.deepEqual(computationWithMap, computation)
})
test('applicative functor no map specifications', t => {
  let computationWithMap = Maybe.of(add)
    .ap(Maybe.of(2))
    .ap(Maybe.of(3))

  let computation = Maybe.of(add(2)).ap(Maybe.of(3))
  t.deepEqual(computationWithMap, computation)
})
