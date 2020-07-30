/**
 * Semigroup
 * 
 * A Semigroup must have a concat method that takes a Semigroup as it's argument
 * 
 * In a non category theory form it simply takes 2 of the same datatype,
 * concats them and returns that same datatype
 * 
 * The type signature for the concat method:
 * concat :: Semigroup a => a ~> a -> a
 * 
 * Fantasy Land spec: https://github.com/fantasyland/fantasy-land#semigroup
 */

const { isSemigroupGuard, typeGuard, typeSafeConcat } = require('./lib/utils');

/**
 * A non-standard (but more friendly) Semigroup
 * It takes a single datatype value argument and returns a container.
 * The containers .concat method can be called with a single datatype value
 * the type of which must match the Semigroup contents.
*/
// Semigroup :: * a -> Semigroup a
const Semigroup = (a) => ({
  a,
  toString: () => `Semigroup(${a})`,
  join: () => a,
  concat: (b) => {
    typeGuard(a, b);
    return Semigroup(
      typeSafeConcat(a, b),
    );
  },
});
// Examples:
// Semigroup('Hello,').concat(' World!'); // => Semigroup(Hello, World!)
// Semigroup(1).concat(3); // => Semigroup(4)
// Semigroup(1).concat('3'); // TypeError
// Semigroup(undefined).concat(undefined); // => Semigroup(undefined)
// Semigroup(undefined).concat(null); // TypeError

/**
 * A more formal Semigroup.
 * It expects a datatype value as it's only argument.
 * The concat method can be called but expects the argument to be another Semigroup
 * containing the same datatype.
 */
// FormalSemigroup :: * a -> FormalSemigroup a
const FormalSemigroup = (a) => ({
  a,
  toString: () => `Semigroup(${a})`,
  join: () => a,
  concat: (b) => {
    isSemigroupGuard(b);
    typeGuard(a, b.join());
    return Semigroup(
      typeSafeConcat(a, b.join()),
    );
  },
});
// Examples:
// FormalSemigroup('Hello,').concat(FormalSemigroup(' World!')); // => FormalSemigroup(Hello, World!)
// FormalSemigroup(1).concat(Semigroup(3)); // => Semigroup(4)
// FormalSemigroup(1).concat(Semigroup('3')); // TypeError
// FormalSemigroup(undefined).concat(Semigroup(undefined)); // => FormalSemigroup(undefined)
// FormalSemigroup(undefined).concat(Semigroup(null)); // TypeError

module.exports = {
  FormalSemigroup,
  Semigroup,
};
