module Tree where

data Tree a = Nil | Br (Tree a) a (Tree a) deriving (Show, Eq)

data MTree a = Empty | Node a [MTree a] deriving (Show, Eq)

foldm f g c Empty = c
foldm f g c (Node x ts) = g (f x) (map (foldm f g c) ts)

mapm f = foldm f Node Empty
