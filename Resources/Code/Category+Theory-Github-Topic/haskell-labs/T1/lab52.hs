
field :: Double -> Double -> Double -> Double
field y1 y2 d = (y1 + y2) * d / 2

-- wylicza przybliżenie całki oznaczonej od a do b dzieląc 
-- przedział na n podprzedziałów i stosując metodę trapezów.
integ :: Int -> (Double -> Double) -> Double -> Double -> Double
integ n f a b = foldr (\x y -> (field (f x) (f (x+d)) d) + y) 0.0 xs 
    where
        d = (b - a) / (fromIntegral n)
        xs = init [a , a+ d .. b] 

test = integ 10 (\x->1.0) 0.0 1.0
test2 = integ 10 (\x->x) 0.0 1.0
