isOdd :: Int -> Writer Bool
isOdd = isEven >=> negate
