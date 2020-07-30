// isSemigroupGuard :: * a -> Boolean || TypeError
const isSemigroupGuard = (a) => {
  if (
    typeof a !== 'object'
    || typeof a.concat !== 'function'
    || typeof a.join !== 'function'
  ) {
    throw new TypeError('The concat input is not a valid Semigroup');
  }
  return true;
};

// getDataType :: * a -> String
const getDataType = (a) => {
  if (a === undefined) {
    return 'Undefined';
  }
  if (a === null) {
    return 'Null';
  }
  return (a).name || ((a).constructor && (a).constructor.name);
}

// typeGuard :: (* a, * b) -> Boolean | TypeError
const typeGuard = (a, b) => {
  const aType = getDataType(a);
  const bType = getDataType(b);

  if (aType !== bType) {
    throw new TypeError(`Type mismatch. Expected ${aType} datatype`);
  }
  return true;
}

// typeSafeConcat :: (* a, * b) -> * ab | TypeError
const typeSafeConcat = (a, b) => {
  const type = getDataType(a);
  switch (type) {
    case 'Number':
    case 'BigInt':
    default:
      return a + b;
    case 'String':
    case 'Array':
      return a.concat(b);
    case 'Object':
      return { ...a, ...b };
    case 'Boolean':
      return Boolean(a + b);
    case 'Function':
      throw TypeError('Cannot concat datatype Function');
    case 'Symbol':
      throw TypeError('Cannot concat datatype Symbol');
    case 'Null':
      return null;
    case 'Undefined':
      return undefined;
  }
}

module.exports = {
  isSemigroupGuard,
  getDataType,
  typeGuard,
  typeSafeConcat,
};
