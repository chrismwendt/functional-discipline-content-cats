import {createTokenizer, regexRule} from 'doken'
import {arrAdd, arrEquals} from './helper'

export class ParseError extends Error {
  constructor(message, token = null) {
    super()

    this.name = 'ParseError'
    this.token = token
    this.message =
      token == null
        ? message
        : `${message} at line ${token.row + 1}, column ${token.col + 1}`
  }
}

export function parseLabel(input) {
  if (input[0] !== '"') return null

  let i = 1
  let braceNesting = 0
  let wrapped = input[1] === '{'

  while (i < input.length) {
    let c = input[i]

    if (c === '"' && braceNesting <= 0) break
    if (c === '\\') i++
    if (c === '{') braceNesting++
    if (c === '}') {
      braceNesting--
      if (braceNesting === 0 && input[i + 1] !== '"') wrapped = false
    }

    i++
  }

  if (input[i] !== '"') return null

  return {
    match: input.slice(0, i + 1),
    value: !wrapped ? input.slice(1, i) : input.slice(2, i - 1),
    wrapped
  }
}

export function parseNode(input) {
  let i = 0

  while (i < input.length) {
    let c = input[i]

    if (
      ['&', '%'].includes(c) ||
      [/^\\\\/, /^\\arrow\s*\[/, /^\\end\s*{tikzcd}/].some(
        regex => regex.exec(input.slice(i)) != null
      )
    ) {
      break
    }

    if (c === '\\') i++
    i++
  }

  let match = input.slice(0, i).trim()
  if (match[match.length - 1] === '\\') match += input[match.length]

  let wrapped = match[0] === '{' && match[match.length - 1] === '}'

  return {
    match,
    value: wrapped ? match.slice(1, -1) : match,
    wrapped
  }
}

export const tokenizeArrow = createTokenizer({
  rules: [
    regexRule('_whitespace', /\s+/y, {lineBreaks: true}),
    regexRule('comma', /,/y),
    regexRule('command', /\\arrow\s*\[/y, {lineBreaks: true}),
    regexRule('end', /\]/y),
    regexRule('alt', /'/y),
    regexRule('direction', /[lrud]+(?!\w)/y),
    regexRule('argName', /([a-zA-Z]+ )*[a-zA-Z]+/y),
    regexRule('argValue', /=(-?\d+(.\d+)?(em)?)/y, {value: match => match[1]}),
    {
      type: 'label',
      lineBreaks: true,
      match: (input, position) => {
        let label = parseLabel(input.slice(position))
        if (label == null) return null

        return {
          length: label.match.length,
          value: label.value
        }
      }
    }
  ]
})

export const tokenize = createTokenizer({
  rules: [
    regexRule('_whitespace', /\s+/y, {lineBreaks: true}),
    regexRule('_comment', /%.*/y),
    regexRule('begin', /\\begin\s*{tikzcd}/y, {lineBreaks: true}),
    regexRule('end', /\\end\s*{tikzcd}/y, {lineBreaks: true}),
    {
      type: 'node',
      lineBreaks: true,
      match: (input, position) => {
        let {match, value} = parseNode(input.slice(position))
        return match.length === 0
          ? null
          : {
              length: match.length,
              value
            }
      }
    },
    {
      type: 'arrow',
      lineBreaks: true,
      match: (input, position) => {
        if (!input.slice(position).startsWith('\\arrow')) return null

        let tokensIter = tokenizeArrow(input.slice(position))
        let tokens = []

        for (let token of tokensIter) {
          if (tokens.length === 0 && token.type !== 'command') return null

          tokens.push(token)
          if (token.type === 'end') break
        }

        let lastToken = tokens[tokens.length - 1]

        return {
          length: lastToken.pos + lastToken.length,
          value: tokens
        }
      }
    },
    regexRule('align', /&/y),
    regexRule('newrow', /\\\\/y)
  ]
})

export function parseArrowTokens(tokens) {
  let arrow = {
    direction: [0, 0],
    value: null,
    labelPosition: 'left'
  }

  let args = []
  let arg = {}

  for (let token of tokens) {
    if (token.type == null) {
      throw new ParseError('Unexpected token', token)
    } else if (token.type === 'direction') {
      let chars = [...token.value]

      arrow.direction = chars.reduce(
        (direction, c) =>
          arrAdd(
            direction,
            {
              l: [-1, 0],
              r: [1, 0],
              u: [0, -1],
              d: [0, 1]
            }[c]
          ),
        [0, 0]
      )
    } else if (token.type === 'label') {
      arrow.value = token.value

      let {done, value: nextToken} = tokens.next()

      if (!done) {
        if (nextToken.type === 'alt') {
          arrow.labelPosition = 'right'
        } else if (
          nextToken.type === 'argName' &&
          nextToken.value === 'description'
        ) {
          arrow.labelPosition = 'inside'
        }
      }
    } else if (token.type === 'argName') {
      arg.name = token.value
      args.push(arg)
    } else if (token.type === 'argValue') {
      arg.value = token.value
    } else if (token.type === 'alt') {
      arg.alt = true
    } else if (token.type === 'comma') {
      arg = {}
    }
  }

  for (let {name, value, alt} of args) {
    Object.assign(
      arrow,
      {
        'near start': {labelPositionLongitudinal: 'nearstart'},
        'very near start': {labelPositionLongitudinal: 'verynearstart'},
        'near end': {labelPositionLongitudinal: 'nearend'},
        'very near end': {labelPositionLongitudinal: 'verynearend'},

        harpoon: {head: `harpoon${alt ? 'alt' : ''}`},
        'two heads': {head: 'twoheads'},
        'no head': {head: 'none'},

        Rightarrow: {line: 'double'},
        dashed: {line: 'dashed'},
        dotted: {line: 'dotted'},
        phantom: {
          labelPosition: 'inside',
          tail: 'none',
          line: 'none',
          head: 'none'
        },

        hook: {tail: `hook${alt ? 'alt' : ''}`},
        'maps to': {tail: 'mapsto'},

        'bend left': {bend: value != null ? +value : 30},
        'bend right': {bend: value != null ? -value : -30},

        'shift left': {shift: value != null ? -value : -1},
        'shift right': {shift: value != null ? value : 1},

        loop: (() => {
          let loop = [0, false]
          let [inAngle, outAngle] = ['in', 'out'].map(name => {
            let arg = args.find(arg => arg.name === name)
            return arg == null ? null : +arg.value
          })

          if (inAngle != null && outAngle != null) {
            let angle = ((inAngle + outAngle) / 2 + 90) % 360

            if ((outAngle - inAngle + 360) % 360 < 180) {
              loop = [angle, true]
            } else {
              loop = [angle, false]
            }
          }

          return {loop}
        })()
      }[name]
    )
  }

  return arrow
}

export function parseArrow(input) {
  return parseArrowTokens(tokenizeArrow(input))
}

export function parseTokens(tokens) {
  let hasBegin = false
  let diagram = {nodes: [], edges: []}
  let [x, y] = [0, 0]

  for (let token of tokens) {
    if (token.type === 'begin') {
      hasBegin = true
      break
    }
  }

  for (let token of tokens) {
    if (token.type == null) {
      throw new ParseError('Unexpected token', token)
    }

    if (token.type === 'end') break
    else if (token.type === 'align') x++
    else if (token.type === 'newrow') {
      x = 0
      y++
    }

    if (token.type === 'node') {
      diagram.nodes.push({
        position: [x, y],
        value: token.value
      })
    } else if (token.type === 'arrow') {
      let arrowTokens = token.value

      // Adjust position info in arrow tokens

      for (let subtoken of arrowTokens) {
        ;[subtoken.row, subtoken.col, subtoken.pos] = arrAdd(
          [subtoken.row, subtoken.col, subtoken.pos],
          [token.row, token.col, token.pos]
        )
      }

      if (arrowTokens.slice(-1)[0].type !== 'end') {
        throw new ParseError('Arrow does not end', token)
      }

      let arrow = parseArrowTokens(arrowTokens[Symbol.iterator]())

      if (arrow.loop || !arrEquals(arrow.direction, [0, 0])) {
        let from = [x, y]
        let to = arrAdd(from, arrow.direction)

        let edge = {
          from,
          to,
          ...arrow
        }

        delete edge.direction
        diagram.edges.push(edge)
      }
    }
  }

  // Transform from/to positions to indices

  let getNodeIndex = position => {
    let index = diagram.nodes.findIndex(node =>
      arrEquals(node.position, position)
    )

    if (index < 0) {
      index = diagram.nodes.length
      diagram.nodes.push({position, value: ''})
    }

    return index
  }

  for (let edge of diagram.edges) {
    edge.from = getNodeIndex(edge.from)
    edge.to = getNodeIndex(edge.to)

    if (edge.loop) {
      edge.to = edge.from
    }
  }

  if (!hasBegin) {
    throw new ParseError('Did not find tikzcd environment')
  }

  return diagram
}

export function parse(input) {
  return parseTokens(tokenize(input))
}
