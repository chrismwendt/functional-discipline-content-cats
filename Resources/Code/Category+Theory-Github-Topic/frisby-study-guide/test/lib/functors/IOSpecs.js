/**
 ** IO functor specifications
 **/
import R from 'ramda'
import test from 'ava'
import { IO } from '../../../src/lib/functors/IO'
import utils from '../../../src/lib/utils'
import fs from 'fs'
import p from 'relative-path'

IO.of = function(f) {
  return new IO(function() {
    return f
  })
}

var join = io => io.join()

const map = R.curry(function(f, io) {
  return io.map(f)
})

const chain = R.curry(function(f, io) {
  return io.chain(f)
})

//const map = f => io => io.map(f)
const readFile = function(fileName) {
  return IO.of(function() {
    return fileName => fs.readFileSync(fileName, 'utf-8')
  })
}

const __f = x => console.log(x)
const print = function(x) {
  return IO.of(function() {
    console.log(x)
    return x
  })
}
const log = R.bind(console.log, console)
const cat = R.compose(chain(print), readFile)
const head = x => x[0]
const catFirstChar = R.compose(R.tap(log), chain(head), cat)

test('IO monad specifications', t => {
  const file2read = p('./', 'IOSpecs.js')
  console.log(`file2read = ${file2read}`)

  t.pass('under construction')
})
2
