/**
 ** Left & Right specifications
 **/
import R from 'ramda'
import test from 'ava'
import moment from 'moment'
import { Left, Right } from '../../../src/lib/functors/Either'
import utils from '../../../src/lib/utils'

/*
 ** helper functios to test either functor
 **
 **/

Left.of = function(x) {
  return new Left(x)
}

Right.of = function(x) {
  return new Right(x)
}
const map = f => e => e.map(f)
const add = x => y => x + y
const asString = x => `${x}`
const add_b = x => add('b')(x)
const log = R.bind(console.log, console) // debugging ramda composiotn

const getAge = now => user => {
  const birthdate = moment(user.birthdate, 'YYYY-MM-DD')
  return birthdate.isValid()
    ? Right.of(now.diff(birthdate, 'years'))
    : Left.of('birthdate could not parsed!!')
}
const fortune = R.compose(
  R.tap(log),
  R.concat('if you survive, you will be '),
  asString,
  add(1)
)

const zoltar = R.compose(map(fortune), getAge(moment()))

test('map on the right will apply the function', t => {
  t.deepEqual(Right.of('rain').map(add_b), Right.of('brain'))
})
test('map on the left wont apply the function', t => {
  t.deepEqual(Left.of('rain').map(add_b), Left.of('rain'))
})
test('right will apply composition ', t => {
  t.deepEqual(
    Right.of({
      host: 'localhost',
      port: 80
    }).map(utils.dot('host')),
    Right.of('localhost')
  )
})
test('left will ignore composition ', t => {
  t.deepEqual(
    Left.of('rolls eyes...').map(utils.dot('host')),
    Left.of('rolls eyes...')
  )
})
test('getAge computation, expected date format', t => {
  t.deepEqual(
    getAge(moment())({
      birthdate: '2005-12-12'
    }),
    Right.of(12),
    'this test will fail for year > 2017'
  )
})
test('getAge computation,unexpected date format', t => {
  t.deepEqual(
    getAge(moment())({ birthdate: 'July 4, 2001' }),
    Left.of('birthdate could not parsed!!')
  )
})
test('getAge computation with unexpected date format', t => {
  t.deepEqual(
    getAge(moment())({ birthdate: 'July 4, 2001' }),
    Left.of('birthdate could not parsed!!')
  )
})
test('either composition, expected date format', t => {
  t.deepEqual(
    zoltar({ birthdate: '2005-12-12' }),
    Right.of(
      'if you survive, you will be 13',
      'this test will fail for year > 2017'
    )
  )
})
test('either composition, unexpected date format', t => {
  t.deepEqual(
    zoltar({ birthdate: 'bad-year' }),
    Left.of('birthdate could not parsed!!')
  )
})
