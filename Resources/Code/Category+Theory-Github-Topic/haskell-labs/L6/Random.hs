module Random where

import System.IO
import Control.Monad.State.Lazy

-- Random numbers

randomNumber :: State Int Int
randomNumber = do
   seed <- get
   put $ (seed*1103515245+12345) `mod` (2^31)
   return $ seed `mod` 2^16


randomTriple :: State Int (Int, Int, Int)
randomTriple = 
    randomNumber  >> get >>= \x -> 
        (randomNumber >> get >>= \y -> 
            (randomNumber >> get >>= \z -> return (x, y, z)))


-- a - minimal value of range element
-- b - maximal value of range element
randomRange :: Int -> Int -> State Int Int
randomRange a b =  
    randomNumber >> get >>= 
        \x -> return (a + x `mod` b)


-- n - minimal range size
-- m - maximal range size
-- a - minimal value of range element
-- b - maximal value of range element
randomList :: Int -> Int -> Int -> Int -> State Int [Int]
randomList n m a b = 
    randomNumber >> 
    randomNumber >> 
    get >>= \seed -> return $ 
    take (evalState (randomRange n m) seed) $ 
    map (\x ->  (a + x `mod` b) ) [execState randomNumber (seed + x) | x <- [1, 2 .. m]]


test :: IO ()
test = 
    putStrLn "Random numbers for seed 254123 :" >>
    putStrLn "- Random number " >>
    print (evalState randomNumber 254123 )  >>
    putStrLn "- Random list of length (4, 10) and values (5, 20) :" >>
    print (evalState (randomList 4 10 5 20) 254123) >>
    putStrLn "- Random list of values (5, 20) :" >>
    print (evalState (randomRange 20 35) 254123)
