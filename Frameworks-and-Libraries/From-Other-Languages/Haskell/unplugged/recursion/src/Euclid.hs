-- Euclid.hs
-- Copyright (C) 2018 Liu Xinyu (liuxinyu95@gmail.com)
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.

module Euclid where

import Data.List
import Data.Tuple (swap)
import Data.Function (on)
import Test.QuickCheck

-- Extended Euclidean Algorithm
gcmex a 0 = (a, 1, 0)
gcmex a b = (g, y', x' - y' * (a `div` b)) where
  (g, x', y') = gcmex b (a `mod` b)

-- solve the linear Diophantine equation ax + by = c
solve a b c | c `mod` g /= 0 = (0, 0, 0, 0) -- no solution
            | otherwise = (x1, u, y1, v)
  where
    (g, x0, y0) = gcmex a b
    (x1, y1) = (x0 * c `div` g, y0 * c `div` g)
    (u, v) = (b `div` g, a `div` g)

-- 2 jars puzzle, optimal by minimize |x| + |y|
jars a b c = (x, y) where
  (x1, u, y1, v) = solve a b c
  x = x1 - k * u
  y = y1 + k * v
  k = minimumBy (compare `on` (\i -> abs (x1 - i * u) + abs (y1 + i * v))) [-m..m]
  m = max (abs x1 `div` u) (abs y1 `div` v)

-- populate the steps
water a b c = if x > 0 then pour a x b y
              else map swap $ pour b y a x
  where
    (x, y) = jars a b c

-- pour from a to b, fill a for x times, and empty b for y times.
pour a x b y = steps x y [(0, 0)]
  where
    steps 0 0 ps = reverse ps
    steps x y ps@((a', b'):_)
      | a' == 0 = steps (x - 1) y ((a, b'):ps)  -- fill a
      | b' == b = steps x (y + 1) ((a', 0):ps)  -- empty b
      | otherwise = steps x y ((max (a' + b' - b) 0,
                                min (a' + b') b):ps) -- a to b

prop_gcm :: Int -> Int -> Bool
prop_gcm a b = (g == gcd a' b') && (a' * x + b' * y == g) where
  (g, x, y) = gcmex a' b'
  (a', b') = (abs a, abs b)

-- Some test data:
-- a = 3, b = 5, g = 4
-- a = 4, b = 9, g = 6
