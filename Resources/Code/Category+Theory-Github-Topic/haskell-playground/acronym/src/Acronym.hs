module Acronym (abbreviate) where

import           Data.Char

abbreviate :: String -> String
abbreviate = map (toUpper . head) . splitString . removeUnderscore

removeUnderscore :: String -> String
removeUnderscore = filter (/= '_')

splitString :: String -> [String]
splitString = map reverse . reverse . foldl reducer [[]]

reducer :: [String] -> Char -> [String]
reducer (h:hs) x
  | isDelimiter x = if null h then h:hs else []:(h:hs)
  | isUpper x = if all isUpper h then (x:h):hs else [x]:(h:hs)
  | otherwise = (x:h):hs

isDelimiter :: Char -> Bool
isDelimiter x
  | x==' ' || x=='-' = True
  | otherwise = False