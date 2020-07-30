-- a + a = 2 x a, where 2 is Bool = True | False

sumToProd :: Either a a -> (Bool, a)
sumToProd = \e -> case e of
    Left x -> (True, x)
    Right x -> (False, x)

prodToSum :: (Bool, a) -> Either a a
prodToSum (b, x) = if b then (Left x) else (Right x)

x :: Either Int Int
x = Left 5
x1 :: (Bool, Int)
x1 = (True, 5)

main :: IO ()
main = do
    putStrLn $ "x: " ++ (show x)
    putStrLn $ "x1: " ++ (show x1)
    putStrLn $ "sumToProd x = x1: sumToProd " ++ (show x) ++ " = " ++ (show $ sumToProd x)
    putStrLn $ "prodToSum x1 = x: prodToSum " ++ (show x1) ++ " = " ++ (show $ prodToSum x1)