main :: IO ()

prodToSum :: (a, Either b c) -> Either (a, b) (a, c)
prodToSum (x, e) = case e of
    Left y -> Left (x, y)
    Right y -> Right (x, y)

sumToProd :: Either (a, b) (a, c) -> (a, Either b c)
sumToProd e = case e of
    Left (x, y) -> (x, Left y)
    Right (x, y) -> (x, Right y)

x :: Either String String
x = Left "b"
y :: Either String Int
y = Right 1

x1 :: Either (String, String) (String, Int)
x1 = Left ("a", "b")
y1 :: Either (String, String) (String, Int)
y1 = Right ("a", 1)

main = do
    putStrLn $ "x = " ++ (show x)
    putStrLn $ "y = " ++ (show y)
    putStrLn $ "x1 = " ++ (show x1)
    putStrLn $ "y1 = " ++ (show y1)
    putStrLn $ "Prod to sum x = " ++ (show $ prodToSum ("a", x))
    putStrLn $ "Prod to sum y = " ++ (show $ prodToSum ("a", y))
    putStrLn $ "Sum to prod x1 = " ++ (show $ sumToProd x1)
    putStrLn $ "Sum to prod y1 = " ++ (show $ sumToProd y1)