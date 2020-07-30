module Counter where
import Control.Monad.State.Lazy


-- QuickSort counter

type Counter = State Int

    
lessEqCnt :: Int -> Int -> Counter Bool
lessEqCnt x y = do
    cnt <- get
    put (cnt + 1) >> return (x <= y )


statement :: ([Int], Counter Bool) -> (Int, Counter Bool) -> ([Int], Counter Bool)
statement (a, b) (c, d) = 
    if (evalState d 0) 
    then (a ++ [c], b >> d) 
    else (a, b >> d)


-- Takes list and returns Counter with elements
-- greater than head of input 
filterR :: [Int]  -> Counter [Int]
filterR [] = return []
filterR (x:xs) = do
    cnt <- get
    let (ys, st) = foldl statement ([], return False) [(y, lessEqCnt x y) | y <- xs]    
    let n = execState st 0
    put (cnt + n) 
    return ys


-- Takes list and returns Counter with elements
-- lesser than head of input 
filterL :: [Int]  -> Counter [Int]
filterL [] = return []
filterL (x:xs) = do
    cnt <- get
    let (ys, st) = foldl statement ([], return False) [(y, lessEqCnt y x) | y <- xs]    
    let n = execState st 0
    put (cnt + n) 
    return ys


quickSortCounter :: Counter [Int] -> Counter [Int]
quickSortCounter st = do
    xs <- st
    case (length xs) of
        0 -> return xs
        _ -> quickSortCounter (filterL xs) >> quickSortCounter (filterR xs)
            

count :: [Int] -> Int
count xs = snd $ runState (quickSortCounter  (return xs)) 0
