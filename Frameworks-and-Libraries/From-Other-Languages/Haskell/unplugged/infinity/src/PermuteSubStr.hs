-- Given a string W and a text T, test if any permutation of W appears in T.
--
-- Examples:
--   W = "ab" T = "excbaode", ==> true, "ba" = permute("ab") in T;
--   W = "ab"  T = "ezdboaxy", ==> false, neither "ab", nor "ba" in T.
--
-- Solution based on Fundamental theorem of arithmetic
-- We use Sieve of Eratosthenes to generate a stream of primes, assign each
-- unique character a prime. We can calculate the number theory finger-print
-- of W by m = product(prime[w]) for each w in W.
-- Then we can scan T with a window of length |W|, calculate the finger-print
-- m' with the same method, whenever m' = m, we found a result.

module PermuteSubStr where

import Data.List (splitAt)
import Data.Map (fromList, (!?))
import FCoalg

exist :: String -> String -> Bool
exist [] _ = True
exist w txt = check m as bs where
  (as, bs) = splitAt (length w) txt
  fp = product $ map primeOf w  -- finger print
  m  = product $ map primeOf as
  check m _ [] = fp == m
  check m (a:as) (b:bs) = if fp == m then True
    else check (m `div` (primeOf a) * (primeOf b)) (as ++ [b]) bs

primeOf c = maybe 1 id (pmap !? c) where
  pmap = fromList $ zip ['a'..'z'] (toList primes)

-- example:
-- exist "ab" "excbaode"

-- Alternatively, sieve of Eratosthenes without F-Coalgebra
primes' = sieve [2..]
sieve (x:xs) = x : sieve [y | y <- xs, y `mod` x > 0]
