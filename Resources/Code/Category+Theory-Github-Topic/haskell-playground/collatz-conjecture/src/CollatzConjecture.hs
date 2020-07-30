module CollatzConjecture (collatz) where

collatz :: Integer -> Maybe Integer
collatz k
  | k < 1 = Nothing
  | k == 1 = Just 0
  | otherwise = fmap succ (collatz next)
  where next = if even k then k `div` 2 else 3 * k + 1