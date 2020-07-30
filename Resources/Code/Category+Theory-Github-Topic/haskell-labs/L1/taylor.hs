module Taylor (taylorSin, taylorSinSeries) where

-- Eager Taylor
-- taylor1 :: Double -> Integer -> Double
-- taylor1 x n 
--         | n > 0 = x ^ (2*n + 1) * (-1)^n / fromInteger(factor (2*n + 1) ) + taylor1 x (n-1)
--         | n == 0 = x


-- Creates list of first n elements of Taylor series of sin x
taylorSinSeries :: Double -> Integer -> [Double]
taylorSinSeries x n = taylorConcat x 1 n [x] x


-- Helper for taylorSinSeries
taylorConcat :: Double -> Integer -> Integer -> [Double] -> Double -> [Double]
taylorConcat x i n s last_el 
    | i <= n+1 = taylorConcat x (i+2) n new_s new_last
    | otherwise = s
    where
        new_last = taylorSinNext x i last_el
        new_s = s ++ [new_last]

-- Oh well...
-- taylorSumSeries :: Double -> Integer -> Double
-- taylorSumSeries x n = sum $ taylorConcat x n 


-- Creates list of first n elements of Taylor series of sin x
taylorSin :: Double -> Integer -> Double
taylorSin x n = taylorAdder x 1 n x x


-- Helper for taylorSin
taylorAdder :: Double -> Integer -> Integer -> Double -> Double -> Double
taylorAdder x i n s last_el 
    | i <= n+1 = taylorAdder x (i+2) n new_s new_last
    | otherwise = s
    where
        new_last = taylorSinNext x i last_el
        new_s = s + new_last


-- Using the last element of series and present index i 
-- it evaluates next element for a given x 
taylorSinNext :: Double -> Integer -> Double -> Double
taylorSinNext x i last_el = (last_el * x^2)  * (-1) /  fromIntegral( (i+1) * (i+2) )

