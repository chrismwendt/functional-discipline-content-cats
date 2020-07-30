{-# LANGUAGE BangPatterns #-}

-- Ord a mean linear order on a
quickSort :: Ord a => [a] -> [a]
quickSort [] = []
quickSort (p:xs) = (quickSort lesser) ++ [p] ++ quickSort(greater)
    where
        lesser = filter (<= p ) xs
        greater = filter( >p) xs

myEven :: Integer -> Integer
myEven a = mod a 2


-- Exercise 69.3
-- mean :: [Float] -> Maybe Float
-- mean [] = Nothing
-- mean xs = Just( sum xs / fromInteger( len xs ) )

mySum :: [Float] -> Float
mySum [] = 0.0
mySum (x:xs) = x + mySum(xs)
 
-- thunks are complicated here
-- and we should avoid double recursion
fibSeq :: Int -> Int
fibSeq 0 = 1
fibSeq 1 = 1
fibSeq n = fibSeq(n-1) + fibSeq(n-2)

factor :: Integer -> Integer
factor 0 = 1
factor n = n * factor (n-1)

