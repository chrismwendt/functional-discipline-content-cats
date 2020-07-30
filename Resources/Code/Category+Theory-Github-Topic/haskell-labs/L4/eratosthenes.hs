module Eratosthenes where
import Data.List

-- Simple implementation of Eratosthenes sieve
eratosthenes :: Integer -> [Integer]
eratosthenes n = erahelp n 2 [2,3 .. n]


erahelp :: Integer -> Integer -> [Integer] -> [Integer]
erahelp n p l 
    | (last nl) /= p = erahelp n (head $ filter (>p) nl) nl  
    | otherwise = l
    where
        nl = l \\ [2*p, 3*p .. n] 
