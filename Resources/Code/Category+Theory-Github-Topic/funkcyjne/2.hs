-- 3
fib :: Int -> Int
fib n = fibs 1 1 n where
    fibs a b times | times == 0 = b | otherwise = fibs b (a+b) (times-1)

-- 4 brzydkie ale trudno
middle :: Int -> Int
middle x y z = (sort [x, y, z]) !! 1

-- 5
qs :: (Ord a) => [a] -> [a]
qs [] = []
qs [a] = [a]
qs [a, b] | a >= b = [b, a] | otherwise [a, b]
qs (x:xs) = (qs [t | t <- xs, t <= x]) ++ [x] ++ (qs [t | t <- xs, t > x])

-- 6
inits :: [a] -> [[a]]
inits xs = [take i xs | i <- [0..length xs]]

-- 7
partitions :: [a] -> [([a], [a])]
partitions xs = [(take i xs, take (length xs - i) n) | i <- [0..length xs]]

-- 8
nub :: (Eq a) => [a] -> [a]
nub [] = []
nub [a] = [a]
nub (x:xs) = [x] ++ [t | t <- nub xs, t /= x]

-- 9
