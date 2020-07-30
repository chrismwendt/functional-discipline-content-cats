import Data.Char

capitalize :: [Char] -> Maybe [Char]
capitalize [] = Nothing
capitalize (x:[]) 
    | isDigit x = Nothing
    | otherwise = Just [toUpper x]
capitalize (x:xs) 
    | isDigit x = Nothing
    | otherwise = fmap (\a -> [toUpper x] ++ a) (capitalize xs)



unaryNumber :: Int -> Maybe [Char]
unaryNumber x
    | x <= 0 = Nothing
    | otherwise = Just $ foldr (++) "" (replicate x "0")


interleave :: [Char] -> [Char] -> Maybe [Char]
interleave [] [] = Just ""
interleave (x:xs) (y:ys) 
    | length xs /= length ys = Nothing
    | otherwise = fmap (\a -> [x, y] ++ a) (interleave xs ys)
