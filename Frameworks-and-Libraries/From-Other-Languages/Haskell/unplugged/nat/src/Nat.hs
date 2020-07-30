module Nat where

import Prelude hiding ((+), (*))

data Nat = Zero | Succ Nat deriving Show

(+) :: Nat -> Nat -> Nat
a + Zero = a
a + (Succ b) = Succ (a + b)

(*) :: Nat -> Nat -> Nat
a *  Zero = Zero
a * (Succ b) = a * b + a

foldn z _ Zero = Zero
foldn z f (Succ n) = f (foldn z f n)
