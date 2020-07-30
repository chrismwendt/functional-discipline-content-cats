module Raindrops
  ( convert
  ) where

import qualified Data.Map as Map

convert :: Int -> String
convert n
  | any (\factor -> n `mod` factor == 0) [3, 5, 7] =
    Map.foldlWithKey
      (\acc k str ->
         if n `mod` k == 0
           then acc ++ str
           else acc)
      ""
      (Map.fromList [(3, "Pling"), (5, "Plang"), (7, "Plong")])
  | otherwise = show n
