module Hamming (distance) where

calculateDist :: String -> String -> Int 
calculateDist xs ys = foldl calculate 0 (zip xs ys) 
  where
   calculate acc pair = 
      if uncurry (==) pair
         then acc
         else acc + 1 

distance :: String -> String -> Maybe Int
distance xs ys
  | length xs == length ys = Just $ calculateDist xs ys 
  | otherwise = Nothing  

