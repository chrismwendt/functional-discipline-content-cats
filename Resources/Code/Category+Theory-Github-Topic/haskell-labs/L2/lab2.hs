funMax :: Ord a => (a -> a) -> (a -> a) -> a -> a
funMax f g x = max (f x) (g x)

sqrt' :: Double -> Double -> Double
sqrt' x eps = newtonSqrt x (x/2) eps (x/2)


-- Epsilon is a difference between two next iterations
newtonSqrt :: Double -> Double -> Double -> Double -> Double
newtonSqrt x p e d
    | d > e = newtonSqrt x np e diff
    | otherwise = p
    where 
        np = p - (p^2 - x) / (2 * p)
        diff = abs $ np - p
