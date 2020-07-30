module Board where
import Data.List 

-- Define board markings
data Mark = E | O | X deriving (Eq, Read)


instance Show Mark where
    show E = " "
    show O = "O"
    show X = "X"


-- Define Board structure
data Board = Empty
            | Board {
                row1 :: [Mark],
                row2 :: [Mark],
                row3 :: [Mark]
            }


instance Show Board where
    show Empty = unlines $ replicate 3 "  |   |  "
    show (Board r1 r2 r3) = unlines [dsp r1, dsp r2, dsp r3]
        where
            dsp row = intercalate " | " (map show row) 
            