module ArmstrongNumbers (armstrong) where

import qualified Data.List as L

toDigits :: Int -> [Int]
toDigits x
  | x < 10 = [x]
  | otherwise = toDigits (x `div` 10) ++ [x `mod` 10] 

armstrong :: Int -> Bool
armstrong x = powSum (toDigits x) == x
  where powSum numList = sum $ L.map (^ length numList) numList
