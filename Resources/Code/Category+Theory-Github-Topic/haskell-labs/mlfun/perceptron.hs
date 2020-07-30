module Perceptron (fit, predict, score, dot) where
    
-- ROSENBLATT PERCEPTRON

-- Given an vectors of features and perceptron weights it predict the class (1, 0)
predict :: [Double] -> [Double] -> Double 
predict (w:ws) xs 
    | val >= 0.0 = 1.0
    | val < 0.0 = 0.0
    where
        val = w + dot xs ws 

-- Executes n epochs of updataing weight on a given batch
fit :: [[Double]] -> [Double] -> Double -> Integer -> [Double]
fit xs ys rate n 
    | (length xs) == (length ys) = fitHelper 1 n rate init_w xs ys
    | otherwise = init_w
    where
        init_w = replicate (length (xs!!0) + 1) 0.0


-- Helper for fitting
fitHelper :: Integer -> Integer -> Double -> [Double] -> [[Double]] -> [Double] -> [Double]
fitHelper i n rate ws xs ys 
    | i <= n = fitHelper (i+1) n rate new_w xs ys
    | otherwise = ws
    where
        new_w = updateWeights rate ws xs ys

    
-- Updates weights for a batch of observations ([[X1], [X2], ...], [y1, y2])
updateWeights :: Double -> [Double] -> [[Double]] -> [Double] -> [Double]
updateWeights rate ws [] _ = ws
updateWeights rate ws _ [] = ws 
updateWeights rate (w:ws) (x:xs) (y:ys) = updateWeights rate new_w xs ys
    where
        update = rate * ( y - predict ws x)
        new_w = [w + update] ++ (zipWith (+) (map (update*) x) ws )


-- SCORE HELPERS
        
-- TP / ALL
score :: [[Double]] -> [Double] -> [Double] -> Double
score xs ys ws = 1 - fromIntegral ( abs (y - y_hat) )/ fromIntegral (length ys)
    where
        m = map (predict ws) xs
        y = length $ filter (==0.0) ys
        y_hat = length $ filter (==0.0) m


-- LINEAR ALGEBRA HELPERS

-- Dot product of two lists
dot :: [Double] -> [Double] -> Double
dot xs ys = sum $ zipWith (*) xs ys
        