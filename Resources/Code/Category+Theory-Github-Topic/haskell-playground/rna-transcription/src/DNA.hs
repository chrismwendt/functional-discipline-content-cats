module DNA (toRNA) where

toRNAChar :: Char -> Either Char Char
toRNAChar 'C' = return 'G'
toRNAChar 'G' = return 'C'
toRNAChar 'T' = return 'A'
toRNAChar 'A' = return 'U'
toRNAChar c   = Left c

toRNA :: String -> Either Char String
toRNA = traverse toRNAChar
