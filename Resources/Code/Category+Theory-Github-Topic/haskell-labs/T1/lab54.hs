myList :: [Int] -> [Int] -> [Int] -> [Int]
myList [] [] [] = []
myList (a:as) (b:bs) (c:cs)
    | a > c = [a] ++ myList as bs cs
    | a < c = [b] ++ myList as bs cs
    | otherwise = [a, b] ++ myList as bs cs

test = take 5 (myList [1,2 ..] [0, 0 .. ] [0, 0 ..])


myList2 :: [Double] -> [Double]
myList2 xs = map (\(x, y, z) -> y) $ filter (\(x, y, z) -> 
    if ((x< y) && (y< z)) then True else False) (zip3 xs (tail xs) (tail $ tail xs) )

test2 = take 10 $ myList2 [0.0,1.0 ..]
