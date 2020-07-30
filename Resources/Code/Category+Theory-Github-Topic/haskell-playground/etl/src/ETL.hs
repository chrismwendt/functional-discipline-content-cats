module ETL (transform) where

import qualified Data.Map as Map
import Data.Char

transform :: Map.Map a String -> Map.Map Char a
transform legacyData = Map.fromList $ concat $ Map.mapWithKey (\key str -> map (\char -> (toLower char, key)) str) legacyData
