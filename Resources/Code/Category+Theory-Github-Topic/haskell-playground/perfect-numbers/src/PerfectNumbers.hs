module PerfectNumbers (classify, Classification(..)) where

import Data.Maybe

data Classification = Deficient | Perfect | Abundant deriving (Eq, Show)

isFactorOf :: Integral a => a -> a -> Bool
isFactorOf f n = n `mod` f == 0 

createFactorList :: Int -> Maybe [Int]
createFactorList x = createList x 1
  where
    createList n
      | n <= 0 = Nothing
      | n > f = if f `isFactorOf` n
        then (f:) <$> createList n (f+1)
        else createList n (f+1)
      | otherwise = Just []

classify :: Int -> Maybe Classification
classify x 
  | isNothing totalNum = Nothing
  | fromJust totalNum == x = Just Perfect
  | fromJust totalNum < x = Just Deficient
  | fromJust totalNum > x = Just Abundant
  | otherwise = Nothing
  where totalNum = sum <$> createFactorList x
