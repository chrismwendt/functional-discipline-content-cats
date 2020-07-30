isEven :: Int -> Writer Bool
isEven n = (n `mod` 2 == 0, "isEven ")

negate :: Bool -> Writer Bool
negate b = (not b, "negate ")
