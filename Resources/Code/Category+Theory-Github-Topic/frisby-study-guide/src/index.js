import R from 'ramda'
import fs from 'fs'
import p from 'relative-path'
import Task from 'data.task'

export const map = f => t => t.map(f)

export const read = path =>
  new Task((reject, resolve) =>
    fs.readFile(path, (err, data) => (err ? reject(err) : resolve(data)))
  )

export const unsafeRun = task =>
  task.fork(
    err => console.log(`error occurred exe task ${err}`),
    data => console.log(data)
  )

const log = R.bind(console.log, console)

const wait = duration => task => setTimeout(() => unsafeRun(task), duration)

const decode = R.compose(map(s => s.toString('utf-8')), read)

const file2read = p('./', 'index.js')
let task = decode(file2read)
export const runner = t => {
  //unsafeRun(task)
  wait(t)(task)
}

runner(1)
