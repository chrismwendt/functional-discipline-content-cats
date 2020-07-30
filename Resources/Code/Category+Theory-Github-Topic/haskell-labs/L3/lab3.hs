import Data.List


-- #2
-- fibloop_old :: Integer -> Integer -> Integer -> Integer
-- fibloop_old n n_1 n_2
--   | n <= 1 = n_1 + n_2
--   | otherwise = fibloop_old (n-1) (n_1 + n_2) n_1

-- fib1 :: Integer -> Integer
-- fib1 n = fibloop_old n 1 0


fibloop :: Integer -> Integer -> Integer -> Integer
fibloop n n_1 n_2
  | n <= 1 = n_1 + n_2
  | otherwise = fibloop (n-1) (0 `seq` (n_1 + n_2)) n_1


fib2 :: Integer -> Integer
fib2 n = fibloop n 1 0

main = print (fib2 100000)


-- #3
avg :: [Double] -> Double
avg [] = 0
avg xs = (foldl' (+) 0.0 xs) / fromIntegral( length xs )

-- #4
elem1 :: (Ord a) => [a] -> a -> Bool
elem1 [] _ = False
elem1 (x:xs) y
    | x == y = True
    | otherwise = elem1 xs y


elem2 :: (Ord a) => [a] -> a -> Bool
elem2 [] _ = False
elem2 xs y = foldl' (\ a b -> a || (b==y)) False xs


-- #6
decreasing :: (Ord a) => [a] -> Bool
decreasing [] = False
decreasing (x:xs) = fst $ foldl' (?) (True, x) xs
    where
        (s, p) ? b = (s && (p > b) , b)

-- Well, this is not going to work:
-- test_decreasing = decreasing [200, 100 ..]

--  #7
anytrue :: [Bool] -> Bool
anytrue [] = False
anytrue xs = foldr (||) False xs

test_anytrue = anytrue ([False, True, False]++repeat False)

