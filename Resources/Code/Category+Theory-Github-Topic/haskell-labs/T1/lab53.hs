myListHelper :: Double -> Double -> Int -> Double
myListHelper a b n = (fromIntegral n) * b / a

myList :: [Double]
myList = [2.5, 3.2, 4] ++ map (\n -> 
    myListHelper (take (2 + n) myList !! n) (take (2 + n) myList !! (n+1)) (n+4)) [0, 1 ..]

test = take 10 myList
