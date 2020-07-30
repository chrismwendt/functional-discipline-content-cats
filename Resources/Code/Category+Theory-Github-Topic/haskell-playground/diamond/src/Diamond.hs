module Diamond
  ( diamond
  ) where

import           Data.Char

diamond :: Char -> Maybe [String]
diamond c
  | not (isLetter c) = Nothing
  | 'A' == c = Just ["A"]
  | otherwise = Just $ _diamond diamondRange (length $ alphaRange c)
  where
    diamondRange = alphaRange c ++ reverse (init $ alphaRange c)
    alphaRange c = ['A' .. c]

_diamond :: [Char] -> Int -> [String]
_diamond [] _        = []
_diamond (x:xs) size = makeLine x size : _diamond xs size

makeLine :: Char -> Int -> [Char]
makeLine letter size = leftSide ++ [center] ++ (reverse leftSide)
  where
    leftSide =
      if letter == 'A'
        then replicate (size - 1) ' '
        else let spacesCount = size - 1 - charDist letter
              in replicate (spacesCount) ' ' ++ [letter] ++ replicate (size - 1 - (spacesCount + 1)) ' '
    center =
      if letter == 'A'
        then 'A'
        else ' '

charDist :: Char -> Int
charDist c = ord c - ord 'A'
