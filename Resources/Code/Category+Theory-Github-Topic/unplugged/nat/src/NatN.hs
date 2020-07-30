module NatN where

import Data.Char (digitToInt)
import Data.List (inits, tails, nub)
import qualified Data.Map as Map
import Data.Array
import Data.Numbers.Primes (primes)  -- cabal install primes
import Test.QuickCheck               -- cabal install QuickCheck

foldn z _ 0 = z
foldn z f n = f (foldn z f (n - 1))

fib = fst . foldn (0, 1) h where
  h (m, n) = (n, m + n)

--take 10 $ map fst $ iterate (\(m, n) -> (n, m + n)) (0, 1)

-- m + ()
plus m = foldn m (+1)

-- m * ()
times m = foldn 0 (+m)

-- m^()
power m = foldn 1 (*m)

-- ()^2
-- (n + 1)^2 = n^2 + 2n + 1
sqr = snd . foldn (0, 0) h where
  h (i, s) = (i + 1, s + 2 * i + 1)

-- ()^m
expo m = snd . foldn (0, 0) h where
  h (i, b) = (i + 1, power (i + 1) m)

-- ()^m with Newton Binomial theorem
-- (n + 1)^m = n^m + (n, 1)n^(m-1) + ... + (n, n-1)n + 1
exp' m n = snd $ foldn (1, 1) h (n - 1) where
  cs = foldn [1] pascal m
  h (i, x) = (i + 1, sum $ zipWith (*) cs xs) where
    xs = take (m + 1) $ iterate (`div` i) x

--      1
--    1   1
--  1   2   1
--1   3   3   1
pascal = gen [1] where
  gen cs (x:y:xs) = gen ((x + y) : cs) (y:xs)
  gen cs _ = 1 : cs

-- sum [1, 3, 5, ...]
sumOdd = snd . foldn (1, 0) h where
  h (i, s) = (i + 2, s + i)

-- There is a line of holes in the forest. A fox hides in one hole.
-- It moves to the next hole every day. If we can
-- check only one hole a day, is there a way to catch the fox?
fox m = foldn (1, m) h n where
  h (c, f) = (c + 2, f + 1)
  n = m - 1 -- solve equation: 2n + 1 = m + n

-- convert a list of digits to number, hex, and decimal.

-- naive dec
dec' :: (Num a) => [a] -> a
dec' = foldr (\c d -> d * 10 + c) 0

dec :: String -> Int
dec = fst . foldr (\c (d, e) -> ((digitToInt c) * e + d, 10 * e)) (0, 1)

hex :: String -> Int
hex = fst . foldr (\c (d, e) -> ((digitToInt c) * e + d, 16 * e)) (0, 1)

decimal :: String -> Float
decimal = fst . foldr (\c (d, e) -> if c == '.' then (d / e, 1) else
                          ((fromIntegral $ digitToInt c) * e + d, 10 * e)) (0, 1)

-- Find the maximum sum of sub list

-- Only find the sum
maxSum :: (Ord a, Num a) => [a] -> a
maxSum = fst . foldr f (0, 0) where
  f x (m, mSofar) = (m', mSofar') where
    mSofar' = max 0 (mSofar + x)
    m' = max mSofar' m

-- return the max sum together with the sub list
maxSum' :: (Ord a, Num a) => [a] -> (a, [a])
maxSum' = fst . foldr f ((0, []), (0, [])) where
  f x (m, (s, xs)) = (m', mSofar) where
    mSofar = max (0, []) (x + s, x:xs)
    m' = max m mSofar

-- brute force naive method for verification purpose
naiveMaxSum :: (Ord a, Num a) => [a] -> a
naiveMaxSum = maximum . (map sum) . (concatMap tails) . inits

-- quickCheck prop_maxSum or verboseCheck prop_maxSum
prop_maxSum :: [Int] -> Bool
prop_maxSum xs = a == b && a == c where
  a = maxSum xs
  b = naiveMaxSum xs
  c = fst $ maxSum' xs

-- Find the longest substr without any duplicated chars

-- Solution 1: Map char to its last occurrence position

-- returns (maxlen, end position)
longest :: String -> (Int, Int)
longest xs = fst2 $ foldr f (0, n, n, Map.empty::(Map.Map Char Int)) (zip [1..] xs) where
  fst2 (len, end, _, _) = (len, end)
  n = length xs
  f (i, x) (maxlen, maxend, end, pos) = (maxlen', maxend', end', Map.insert x i pos) where
    maxlen' = max maxlen (end' - i + 1)
    end' = case Map.lookup x pos of
      Nothing -> end
      Just j -> min end (j - 1)
    maxend' = if end' - i + 1 > maxlen then end' else maxend

-- Solution 2: Map char to a prime number
primeArr = listArray (0, 127) primes
primeOf c = primeArr ! (fromEnum c)

longestNT :: String -> (Int, String)
longestNT = hd . foldr f ((0, []), (0, []), 1) where
  hd (a, _, _) = a
  f x (m, (n, xs), prod) = if prod `mod` p > 0
    then update m (n + 1, x:xs) (prod * p)
    else update m (length xs', xs') (product $ map primeOf xs')
    where
      p = primeOf x
      update a b prod = (max a b, b, prod)
      xs' = x : takeWhile (x /=) xs

-- brute force naive method for verification purpose
naiveLongest :: (Eq a) => [a] -> Int
naiveLongest = maximum . (map length) . (filter (\xs -> xs == nub xs)) . (concatMap tails) . inits

prop_longest :: String -> Bool
prop_longest xs = a == b && a == c where
  a = fst $ longest ys
  b = fst $ longestNT ys
  c = naiveLongest ys
  ys = map (\c -> (toEnum $ (fromEnum c) `mod` 128)::Char) xs


-- Fibonacci number with Matrix multiplication

mul (a11, a12, a21, a22) (b11, b12, b21, b22) =
  (a11 * b11 + a12 * b21, a11 * b12 + a12 * b22,
   a21 * b11 + a22 * b21, a21 * b12 + a22 * b22)

mulv (a11, a12, a21, a22) (b1, b2) =
  (a11 * b1 + a12 * b2,
   a21 * b1 + a22 * b2)

powm m n = pow' m n (1, 0, 0, 1) where
  pow' m n acc | n == 0 = acc
               | even n = pow' (m `mul` m) (n `div` 2) acc
               | otherwise = pow' (m `mul` m) (n `div` 2) (m `mul` acc)

fibm n = fst $ powm (0, 1, 1, 1) n `mulv` (0, 1)

-- map fibm [0..10]
