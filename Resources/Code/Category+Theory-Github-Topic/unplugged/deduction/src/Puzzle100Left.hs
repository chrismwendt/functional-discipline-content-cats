module Puzzle100Left where

dec :: (Num a) => [a] -> a
dec = foldr (\d n -> n * 10 + d) 0

append x = foldr (:) [x]

onLast f = foldr h [] where
  h x [] = [(f x)]
  h x xs = x : xs

add d exp = [((append d) `onLast`) `onLast` exp,
             (append [d]) `onLast` exp,
             (append [[d]]) exp]
