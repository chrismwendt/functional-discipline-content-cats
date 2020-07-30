data FullList a = Single a | Cons a (FullList a)

instance Functor FullList where
  fmap f (Single x)  = Single (f x)
  fmap f (Cons x fx) = Cons (f x) (fmap f fx)
  
instance Monad FullList where
  return x                    = Single x
  (Single x)  >>= f           = f x
  (Cons x fx) >>= f           = Cons (f x) (fx >>= f)
  join (Single (Single x))    = Single x
  join (Single (Cons x fx))   = Cons x fx
  join (Cons (Single x) ffx)  = Cons x ffx
  join (Cons (Cons x fx) ffx) = Cons (join (Cons x fx)) ffx
  
instance Comonad FullList where
  extract (Single x)    = x
  extract (Cons x fx)   = x
  f =>> (Single x)      = f x
  f =>> (Cons x fx)     = f x
  duplicate (Single x)  = Cons x (Single x)
  duplicate (Cons x fx) = Cons x (duplicate (fx x))
