{-# LANGUAGE DeriveFunctor #-}

module HyloQuick
    ( qSort
    , unfoldList
    , foldTree
    ) where

import Data.List
import Data.Fix ( hylo, cata, ana, Fix )

type Algebra f c = f c -> c
type CoAlgebra f c = c -> f c

data TreeF a r = Leaf | Node a r r
  deriving ( Functor, Show )

split :: Ord a => CoAlgebra (TreeF a) [a]
split [] = Leaf
split (a:as) = Node a l r
  where (l, r) = partition (< a) as

join :: Algebra (TreeF a) [a]
join Leaf = []
join (Node a l r) = l ++ [a] ++ r

qSort :: Ord a => [a] -> [a]
qSort = hylo join split  -- and even more terse: qSort = split ~> join

unfoldList :: Ord a => [a] -> Fix ( TreeF a )
unfoldList = ana split

foldTree :: Ord a => Fix ( TreeF a ) -> [a]
foldTree = cata join