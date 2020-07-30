/**
 ** Ramda lense specifications
 **
 **/
import R from 'ramda'
import test from 'ava'
import utils from '../../../src/lib/utils'
import fs from 'fs'
import p from 'relative-path'
import Task from 'data.task'

const addrs = [
  {
    street: { no: '1122', name: 'boogie boogie Ave' },
    city: 'San Francisco',
    state: 'CS',
    zip: '94131'
  },
  {
    street: { no: '666', name: 'Infidel Ave' },
    city: 'Hell',
    state: 'HL',
    zip: '6666'
  }
]
const user = { id: 3, name: 'bob', address: addrs }

test('lens view specifications', t => {
  const nameLense = R.lens(R.prop('name'), R.assoc('name'))
  t.truthy(user.name === R.view(nameLense, user))
})

test('lens view of an array specifications', t => {
  const addressLense = R.lensPath(['address', 0, 'street', 'name'])
  t.truthy(user.address[0].street.name === R.view(addressLense, user))
})

test('lens set property specifications', t => {
  const addressLense = R.lensPath(['address', 0, 'street', 'name'])
  const computedUser = R.set(addressLense, '3rd street', user)
  t.truthy(computedUser.address[0].street.name === '3rd street')
})

test('lens over property specifications', t => {
  const nameLense = R.lens(R.prop('name'), R.assoc('name'))
  const computedUser = R.over(nameLense, R.toUpper, user)
  t.truthy(computedUser.name === user.name.toUpperCase())
})

test('lens composition specifications', t => {
  let purchase = { name: 'Hover Board', price: 1000 }
  t.pass()
})
