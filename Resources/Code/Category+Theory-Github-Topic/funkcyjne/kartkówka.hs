import Control.Monad.Writer
import Data.List

-- wszystkie pary liczb względnie pierwszych do n
z1 :: Int -> [(Int, Int)]
z1 n = [(x, y) | x <- [2..n], y <- [x..n], gcd x y == 1]

-- funkcja rekurencyjna f0 = f1 = 0, fn = fn-1 - fn-2 + n
z2 :: Int -> Int
z2' = 0 : 0 : zipWith (-) (tail z2') (zipWith (+) [2..] z2')
z2 n = -(z2' !! n)

-- n-elementowe podciągi kolejnych elementów listy
z3 :: [Int] -> Int -> [[Int]]
z3 xs n = filter (\x -> length x == n) $ [(take n).(drop i) $ xs | i <- [0.. length xs]]

-- suma euler(k)/2^k od k = 1 do n
z4 :: Int -> Float
z4 n = sum [fromIntegral (euler k) / fromIntegral 2^k | k <- [1..n]] where euler x = length [e | e <- [1..x], gcd e x == 1]

-- wypisywanie znajdywania kolejnych dzielników pierwszych i liczba dzielników pierwszych na końcu
z5 :: Int -> Writer [String] Int
z5' :: Int -> Int -> [Int] -> Writer [String] Int
z5' d n acc
    | n == 1 = do
        tell ["Finished"]
        return $ length.nub $ acc
    | n `mod` d == 0 = do 
        tell ["Found " ++ show d]
        z5' d (n `div` d) (d:acc)
    | otherwise = do
        z5' (d+1) n acc

z5 n = z5' 2 n []