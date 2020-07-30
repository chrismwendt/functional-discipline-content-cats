/**
 ** data.Task specifications
 **  These specifications are from https://github.com/folktale/data.task
 **
 **/
import R from 'ramda'
import test from 'ava'
import utils from '../../../src/lib/utils'
import fs from 'fs'
import p from 'relative-path'
import Task from 'data.task'

const add = x => y => x + y
const add10 = add(10)

const map = f => t => t.map(f)

const read = path =>
  new Task((reject, resolve) =>
    fs.readFile(path, (err, data) => (err ? reject(err) : resolve(data)))
  )

const unsafeRun = task =>
  task.fork(
    err => console.log(`error occurred exe task ${err}`),
    data => console.log(data)
  )
// Task.of = function(t) {
//   return new Task((reject, resolve) => (t ? resolve(t) : reject(t)))
// }
const scheduleOnce = when => task => wait(when)(task)

const log = R.bind(console.log, console)

const wait = duration => task => setTimeout(() => unsafeRun(task), duration)

const decode = R.compose(map(s => s.toString('utf-8')), read)
const find = R.compose(map(t => t.match('join')), decode)
const file2read = p('./', 'IOSpecs.js')

test('task specifications', t => {
  const _task = read(file2read)

  unsafeRun(decode(file2read))

  t.pass()
})
test('task scheduler specifications', t => {
  let task = decode(file2read)
  scheduleOnce(2)(task)
  t.pass()
})
test('string matcher specifications', t => {
  let taskToRun = unsafeRun(find(file2read))
  t.pass()
})
test('task monad chain specifications', t => {
  const t2 = new Task((reject, resolve) => resolve(2))
  const addtask = t => new Task((reject, resolve) => resolve(add10(t)))
  unsafeRun(t2.chain(addtask))
  t.pass()
})
