execute :: [Char] -> Int -> Int -> Int
execute "+" a b = a + b
execute "*" a b = a * b
execute "-" a b = a - b


main :: IO ()
main = do
    putStrLn "Wow! You can do +, -, * on ints! "
    putStrLn "What is the symbol between x and y? "
    o <- getLine
    putStrLn "What is the x? "
    x <- getLine >>= return . (\a -> read a :: Int)
    putStrLn "What is the y? "
    y <- getLine >>= return . (\a -> read a :: Int)
    print $ execute o x y
