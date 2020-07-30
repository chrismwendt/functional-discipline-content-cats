data Identity a = Identity a
  deriving(Show)

instance Functor Identity where
  fmap f (Identity x) = Identity (f x)

instance Monad Identity where
  return x                     = Identity x
  (Identity x) >>= f           = f x
  join (Identity (Identity x)) = Identity x

instance Comonad Identity where
  extract (Identity x)   = x
  f =>> (Identity x)     = Identity (f x)
  duplicate (Identity x) = Identity (Identity x)

