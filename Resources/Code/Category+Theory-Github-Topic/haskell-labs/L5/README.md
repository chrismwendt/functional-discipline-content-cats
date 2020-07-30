## Monad in category theory
> A monad is a structure that is a lot like a monoid,

If `C` is a category, a monad on `C` consists of an endofunctor  `T : C → C` 
together with two natural transformations: 
-  `η : 1 → T` (the unit)
-  `μ : T^2  → T`(the multiplication)

The name “monad” and the terms “unit”, “multiplication” and “associativity” bear a clear analogy with monoids. 

## Monad in Haskell
Monad could be seen as a structure with:
- type constructor `m`.
- a function of type `m a -> (a -> m b) -> m b` for chaining the output of one function into the input of another.
- a function of type `a -> m a` for injecting a normal value into the chain, that is, it wraps a type a with the type constructor m.

```haskell
class Monad m where
    -- chain
    (>>=)  :: m a -> (a -> m b) -> m b
    -- inject
    return :: a -> m a
```

RWH, p. 329
> As we noted in “The True Nature of Return” on page 187, the choice of the name return is a little unfortunate. That name is widely used in imperative languages, where it has a fairly well-understood meaning. In Haskell, its behavior is much less constrained. In particular, calling return in the middle of a chain of functions won’t cause the chain to exit early. A useful way to link its behavior to its name is that it returns a pure value (of type a) into a monad (of type m a). But really, “inject” would be a better name.


and the full definition of a monad:

```haskell
class Monad m where
    (>>=)  :: m a -> (  a -> m b) -> m b
    (>>)   :: m a ->  m b -> m b
    -- a >> f = a >>= \_ -> f
    return :: a -> m a
    fail   :: String -> m a
```

## Monad laws

```haskell
return a >>= k                  =  k a
m        >>= return             =  m
m        >>= (\x -> k x >>= h)  =  (m >>= k) >>= h
```


## Links
https://wiki.haskell.org/Monad

https://ncatlab.org/nlab/show/monad
