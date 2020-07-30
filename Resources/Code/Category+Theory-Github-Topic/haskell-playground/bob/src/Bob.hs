module Bob (responseFor) where

import Prelude as P
import           Data.Char

responseFor :: String -> String
responseFor xs
  | P.all isSpace xs = "Fine. Be that way!"
  | P.all isUpperIfAlpha xs = "Whoa, chill out!"
  | safeLast xs == Just '?' = "Sure."
  | safeLast xs == Just '?' && P.all isUpper (P.init xs) = "Calm down, I know what I'm doing!"
  | otherwise = "Whatever."
  where
    safeLast [] = Nothing
    safeLast ss = Just (P.last ss)
    isUpperIfAlpha c = isUpper c || not (isAlpha c)