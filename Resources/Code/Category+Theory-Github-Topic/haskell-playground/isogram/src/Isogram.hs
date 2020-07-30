module Isogram (isIsogram) where

import qualified Data.Map as Map
import Data.List (map, intercalate)
import Data.List.Split
import Data.Char (toUpper)
import Data.String (words)

ignore :: String -> String
ignore s = intercalate "" $ concatMap (splitOn "-") $ words s

isIsogram :: String -> Bool
isIsogram s = length (extractKeys s) == length (ignore s)
  where
    extractKeys str = Map.keys $ Map.delete '-' $ Map.delete ' ' $ Map.fromList $ map (\c -> (toUpper c, 1)) str
