module Pangram (isPangram) where

import Data.Char
import Data.List

alpha = ['a'..'z']

isAlphaChar :: Char -> Bool
isAlphaChar c = (isLetter c) && (isAscii c)

isPangram :: String -> Bool
isPangram text = check
  where
    s = map toLower (filter isAlphaChar text)
    s' = sort $ nub s
    check = alpha == s'
