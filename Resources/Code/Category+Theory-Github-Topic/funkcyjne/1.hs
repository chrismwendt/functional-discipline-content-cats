-- to jest dosłownie pierwsza styczność z tym językiem
-- te rozwiązania najpewniej są bolesne dla kogokolwiek bardziej doświadczonego
-- czytać z odpowiednim dystansem
-- 3
euler :: Int -> Int
euler n = length [k | k<-[1..n], gcd k n == 1]

eulerSum :: Int -> Int
eulerSum n = sum [euler k | k<-[1..n], n `mod` k == 0]

-- 4
pythagorean :: Int -> [(Int, Int, Int)]
pythagorean n = [(a, b, c) | a<-[1..n], b<-[1..n], c<-[1..b], a^2 + b^2 == c^2, gcd b c == 1]

-- 5
fibb :: Int -> Int
fibb 0 = 1
fibb 1 = 1
fibb n = fibb(n-2) + fibb (n-1)

fibb2 :: Int -> Int
fibb2 n | n <= 1 = 1
        | n > 1  = fibb2 (n-1) + fibb2 (n-2)

-- 6
binom :: Int -> Int -> Int
binom _ 0 = 0
binom n 1 = n
binom 1 _ = 0
binom n k = binom (n-1) k + binom (n-1) (k-1)

-- 7
perfect :: Int -> [Int]
perfect n = [k | k<-[2..n], sum [l | l <-[1..k-1], k `mod` l == 0] == k]