module DNA (nucleotideCounts, Nucleotide(..)) where

import Data.Map (Map)
import qualified Data.Map as M
import Text.Read
import Control.Applicative

data Nucleotide = A | C | G | T deriving (Eq, Ord, Show, Read)

nucleotideCounts :: String -> Either String (Map Nucleotide Int)
nucleotideCounts =
  foldl reducer $ Right emptyMap

reducer :: Either String (Map Nucleotide Int) -> Char -> Either String (Map Nucleotide Int)
reducer (Right acc) rawNucl =
  case maybeNucl of
    Just nucl -> Right $ M.adjust (+1) nucl acc
    _  -> Left "Error"
  where maybeNucl = readMaybe [rawNucl] :: Maybe Nucleotide
reducer (Left _) _ = Left "Error"

emptyMap :: Map Nucleotide Int
emptyMap = M.fromList [(A,0),(C,0),(G,0),(T,0)]
