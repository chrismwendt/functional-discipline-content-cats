module Puzzle100 where

import Data.List (intercalate)

type Expr = [Term]     -- | T1 + T2 + ... Tn
type Term = [Factor]   -- | F1 * F2 * ... Fm
type Factor = [Int]    -- | d1d2...dk

dec :: Factor -> Int
dec = foldl (\n d -> n * 10 + d) 0

expr d = [[[d]]]  -- | single digit expr

-- |
-- > eval = sum . map (product . (map dec))
--   directly using foldr/build fusion gives:
-- > eval = foldr (\t ts -> (foldr ((*) . fork (dec, id)) 1 t) + ts) 0
eval [] = 0
eval (t:ts) = product (map dec t) + eval ts

-- | 1, brute-force, exhausted search
extend :: Int -> [Expr] -> [Expr]
extend d [] = [expr d]
extend d es = concatMap (add d) es where
  add :: Int -> Expr -> [Expr]
  add d ((ds:fs):ts) = [((d:ds):fs):ts,   -- | insert nothing between digits
                        ([d]:ds:fs):ts,   -- | insert "*", add a new factor
                        [[d]]:(ds:fs):ts] -- | insert "+", add a new term

-- | usage: sol1 [1..9] or map str (sol1 [1..9])
sol1 :: [Int] -> [Expr]
sol1 = filter ((==100) . eval) . foldr extend []

-- | 2, improved exhausted search, filter out the invalid
--      candidate as early as possible

-- Express the value in 4 parts: type Val = (Int, Int, Int, Int)
--    exponent,
--    value of first factor,
--    value of rest factors,
--    value of rest terms.

value (_, f, fs, ts) = f * fs + ts

-- expand :: Int -> [(Expr, Val)] -> [(Expr, Val)]
expand d [] = [(expr d, (10, d, 1, 0))]
expand d evs = concatMap ((filter ((<= 100) . value . snd)) . (add d)) evs where
  add d (((ds:fs):ts), (e, f, vfs, vts)) =
    [(((d:ds):fs):ts, (10 * e, d * e + f, vfs, vts)),
     (([d]:ds:fs):ts, (10, d, f * vfs, vts)),
     ([[d]]:(ds:fs):ts, (10, d, 1, f * vfs + vts))]

-- | usage: sol2 [1..9] or map str (sol2 [1..9])
sol2 :: [Int] -> [Expr]
sol2 = map fst . filter ((==100) . value . snd) . foldr expand []

-- Is it possible to simplify the below expr?
str = (join "+") . (map ((join "*") . (map (show . dec)))) where
  join = intercalate
