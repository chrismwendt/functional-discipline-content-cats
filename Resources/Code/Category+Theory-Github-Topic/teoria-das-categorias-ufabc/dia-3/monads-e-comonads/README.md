# Alguns Functors possuem instâncias de Monad e Comonad, escreva essas instâncias (na linguagem que preferir) para:
 
 a. O Functor Identity:
 
 ```haskell
 data Identity a = Identity a
 
 instance Functor Identity where
   fmap f (Identity x) = ???
   
instance Monad Identity where
  return x                     = ???
  (Identity x) >>= f           = ???
  join (Identity (Identity x)) = ???
  
instance Comonad Identity where
  extract (Identity x)   = ???
  f =>> (Identity x)     = ???
  duplicate (Identity x) = ???
 ```

b. O tipo lista não-vazia:

```haskell
data FullList a = Single a | Cons a (FullList a)

instance Functor FullList where
  fmap f (Single x)  = ???
  fmap f (Cons x fx) = ???
  
instance Monad FullList where
  return x                    = ???
  (Single x)  >>= f           = ???
  (Cons x fx) >>= f           = ???
  join (Single (Single x))    = ???
  join (Single (Cons x fx))   = ???
  join (Cons (Single x) ffx)  = ???
  join (Cons (Cons x fx) ffx) = ???
  
instance Comonad FullList where
  extract (Single x)    = ???
  extract (Cons x fx)   = ???
  f =>> (Single x)      = ???
  f =>> (Cons x fx)     = ???
  duplicate (Single x)  = ???
  duplicate (Cons x fx) = ???
```
