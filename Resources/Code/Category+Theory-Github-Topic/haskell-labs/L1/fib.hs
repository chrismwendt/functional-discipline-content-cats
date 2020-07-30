fibloop :: Integer -> Integer -> Integer -> Integer
fibloop n n_1 n_2
  | n <= 1 = n_1 + n_2
  | otherwise = fibloop (n-1) (n_1+n_2) n_1

fib' :: Integer -> Integer
fib' n = fibloop n 1 0


-- myClip :: Double -> Double -> Double -> Double
-- myClip x n m = max n (min x m) 

-- kind of magic 
-- myClip returns a function 
myClip :: Int -> Int -> Int -> Int
myClip n m = max n . min m


