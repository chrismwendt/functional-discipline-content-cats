{-# Language InstanceSigs #-}

-- F-Algebra examples (without using Fixed point)

module FAlgebra where

-- F A -> A, F is functor
type Algebra f a = f a -> a

-- Natural number example

data NatF a = ZeroF | SuccF a deriving Show

data Nat = Zero | Succ Nat deriving Show

fromInt :: Int -> Nat
fromInt 0 = Zero
fromInt n = Succ $ fromInt (n-1)

-- Catamorphism
-- For NatF/Nat, not a generic one like:
--   cata :: Functor f => (f a -> a) -> (Fix f -> a)
--   cata f = f . fmap (cata f) .unFix
cata :: (NatF a -> a) -> (Nat -> a)
cata f Zero = f ZeroF
cata f (Succ x) = f (SuccF (cata f x))

-- example 1.1
toInt :: Nat -> Int
toInt = cata eval where
  eval :: NatF Int -> Int
  eval ZeroF = 0
  eval (SuccF x) = x + 1

-- example 1.2
toFib :: Nat -> (Integer, Integer)
toFib = cata fibAlg where
  fibAlg :: NatF (Integer, Integer) -> (Integer, Integer)
  fibAlg ZeroF = (1, 1)
  fibAlg (SuccF (m, n)) = (n, m + n)

fibAt = fst . toFib . fromInt

-- List example

data ListF a b = NilF | ConsF a b deriving Show

data List a = Nil | Cons a (List a) deriving Show

fromList :: [a] -> List a
fromList [] = Nil
fromList (x:xs) = Cons x (fromList xs)

cataL :: (ListF a b -> b) -> (List a -> b)
cataL f Nil = f NilF
cataL f (Cons x xs) = f (ConsF x (cataL f xs))

-- example 1.1
--  usage: len $ fromList [1..5]
len :: (List a) -> Int
len = cataL lenAlg where
  lenAlg :: ListF a Int -> Int
  lenAlg NilF = 0
  lenAlg (ConsF _ n) = n + 1

-- example 2.2
--  usage: sumL $ fromList [1..5]
sumL :: (Num a) => (List a) -> a
sumL = cataL sumAlg where
  sumAlg :: (Num a) => ListF a a -> a
  sumAlg NilF = 0
  sumAlg (ConsF x y) = x + y
