module List where

import Prelude hiding ((++))

data List a = Nil | Cons a (List a) deriving (Show, Eq)

(++) :: List a -> List a -> List a
Nil ++ y = y
(Cons a x) ++ y = Cons a (x ++ y)
