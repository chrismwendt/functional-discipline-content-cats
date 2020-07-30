import Data.List


-- #1
fibList :: [Integer]
fibList = [0, 1] ++ zipWith (+) fibList (drop 1 fibList)

-- #2
-- Sum numbers in list form ex. 103 = [1, 0, 3]
sumList :: [Int] -> [Int] -> [Int]
sumList xs ys 
    | lxs > lys = (take d xs)  ++ s
    | otherwise = (take d ys)  ++ s
    where
        lxs = length xs
        lys = length ys
        d = abs (lxs - lys) 
        s = reverse $ zipWith (+) (reverse xs) (reverse ys)


-- #3
data Person = Person {
    lastName :: String,
    name1 :: String,
    name2 :: String
} deriving Show


instance Eq Person where
    (Person x y z) == (Person a b c) = (x == a) && (y == b) && (z == c)


instance Ord Person where
    compare (Person x y z) (Person a b c) 
        | (x == a) && (y == b) = compare z c
        | x == a = compare y b
        | otherwise = compare x y


-- #6
-- Lazy filter implementation
lazyFilter :: (a -> Bool) -> [a] -> [a]
lazyFilter c xs = foldr f [] xs
    where
        f a b | (c a) = [a] ++ b | otherwise = b


test = take 5 $ lazyFilter ((== 0) . (`mod` 2)) [1,2..]

-- #7
quickSort :: (Ord a) => [a] -> [a]
quickSort [] = []
quickSort (x:xs) = quickSort ls ++ pivots ++ quickSort rs
    where
        pivots = filter (==x) (x:xs)
        ls = filter (<x) xs
        rs = filter (>x) xs


-- #8
leibnitzpi :: Double
leibnitzpi = 4.0 * (fst $ foldl' (?) (1.0, 1.0) (map (1/) [3, 5 .. 20001]))
    where
        (x, i) ? y = (x  + (-1.0 * i) * y, -1.0 * i)
        