-- install Haskell Platform https://www.haskell.org/platform/

  -- https://wiki.haskell.org/Tutorials
  -- http://stackoverflow.com/questions/1012573/getting-started-with-haskell

  -- http://learnyouahaskell.com/chapters
  -- http://book.realworldhaskell.org/read/

  -- https://learnxinyminutes.com/docs/haskell/

  -- Krishna Haskell Tutorial
  -- https://www.youtube.com/playlist?list=PLwiOlW12BuPZUxA2gISnWV32mp26gNq56

  -- LazyCast Haskell Tutorial
  -- https://www.youtube.com/playlist?list=PLvj5k87ljYYHwOOcdGvS3qi85IvjOW--8

  -- Pluralsight Haskell Fundamentals
  -- https://app.pluralsight.com/library/courses/haskell-fundamentals-part1

-- compile - create executable
-- $ ghc hello-world.hs

-- GHC interactive
-- $ ghci

  -- load functions from haskell_examples.hs by
  -- $ :l haskell_examples

  -- reload file by
  -- $ :r

  -- load modules with
  -- $ :m + Data.list Data.Map Data.Set

  -- check type by
  -- $ :t valueToCheck

  -- check info
  -- $ :i sth

  -- check kind (types are the labels of values and kinds are the labels of types)
  -- $ :k SomeType



import Data.List

-- qualified import
-- import qualified Data.Sequence as Seq
-- :t empty - not in scope
-- :t Seq.empty - Seq.empty :: Seq.Seq a

-- explicit import
-- import Data.Set (empty, size)

-- hiding imports
-- import Data.Set hiding (empty, size)

-- Type class instances ingnore any explicit import list, automatically imported with the module


main :: IO()
main = do

  -- string concatenation
  print ("aaa" ++ "bbb")

  print (succ 10)
  print (min 2 3)
  print (max 2 3)
  print (2 `max` 3)


printHello = putStrLn "Hello"
mySumFn a b = a + b
squareMe x = x * x
doubleSmallNumber x = if x > 100
                        then x
                        else x*2

nestedFnExample = do
  let myMul a b = a * b
  print (myMul 2 5)



--------------------------------------
-- LISTS
--------------------------------------

listExample = do

  let myList = [1 ,2 ,3, 4, 5, 6]

  putStrLn "my list is: "
  print myList

  print (myList !! 1)
  print (head myList)
  print (tail myList)
  print (last myList)

  putStrLn "Everything except last element:"
  print (init myList)

  print (length myList)

  putStrLn "Is my list empty?"
  print (null myList)

  print (reverse myList)

  putStrLn "is 6 element of my list?"
  print (6 `elem` myList)

  -- string is also list
  -- take function is taking x elements from the begining of list
  -- cycle function takes list and cycles it into infinite list (so we must use take to cut it)
  -- repeat function produces infinite list of just one element
  print (take 12 (cycle "LOL "))

  -- [5, 5, 5]
  print (replicate 3 5)



--------------------------------------
-- TUPLES
--------------------------------------

tuplesExample = do

  -- first element of tuple
  print (fst (1, 2))

  -- second element of tuple
  print (snd (1, 2))

  -- zip takes two lists and creates one list of tuples
  print (zip [1 .. 5] ["one", "two", "three", "four", "five"])



--------------------------------------
-- LIST COMPREHENSION
--------------------------------------

listCompExample = do

  -- make list of doubled numbers from 1 to 10
  print ([x*2 | x <- [1..10]] )

  -- with condition (or predicate, we can use many of them after comma)
  print ([x*2 | x <- [1..10], x*2 >= 12] )

  -- function that takes list xs,
  -- filter odd numbers and map it to boom if greater than 10 or to bang
  let boomBangs xs = [ if x < 10 then "BOOM!" else "BANG!" | x <- xs, odd x]
  print (boomBangs [8, 9, 11, 12])

  -- which right triangle that has integers for all sides
  -- and all sides equal to or smaller than 10 has a perimeter of 24
  let rightTriangles = [ (a,b,c) | c <- [1..10], b <- [1..c], a <- [1..b], a^2 + b^2 == c^2, a+b+c == 24]
  print rightTriangles



--------------------------------------
-- FUNCTION SYNTAX
--------------------------------------

-- function with type declaration
removeNonUppercase :: [Char] -> [Char]
removeNonUppercase st = [ c | c <- st, c `elem` ['A'..'Z']]

-- 3 parameters and return type
addThree :: Int -> Int -> Int -> Int
addThree x y z = x + y + z

-- guard patterns
sayMe :: (Integral a) => a -> String
sayMe 1 = "One!"
sayMe 2 = "Two!"
sayMe 3 = "Three!"
sayMe 4 = "Four!"
sayMe 5 = "Five!"
sayMe x = "Not between 1 and 5"

factorial :: (Integral a) => a -> a
factorial 0 = 1
factorial n = n * factorial (n - 1)

fibonacci :: (Integral a) => a -> a
fibonacci 0 = 0
fibonacci 1 = 1
fibonacci n = fibonacci (n-1) + fibonacci (n-2)

third :: (a, b, c) -> c
third (_, _, z) = z

-- recursive function
sum' :: (Num a) => [a] -> a
-- base case
sum' [] = 0
-- recursive case
sum' (x:xs) = x + sum' xs

zip' :: [a] -> [b] -> [(b, a)]
zip' _ [] = []
zip' [] _ = []
zip' (a:aa) (b:bb) = (b, a): zip' aa bb

-- function application
-- ($) :: (a -> b) -> a -> b
-- f g z x is like (((f g) z) x)
-- f $ g $ z x is like (f (g (z x)))

-- function composition
-- (.) :: (b -> c) -> (a -> b) -> a -> c
-- f . g = \x -> f (g x)

--------------------------------------
-- HIGH ORDER FUNCTIONS
--------------------------------------

map' :: (a -> b) -> [a] -> [b]
map' _ [] = []
map' f (x:xs) = f x : map f xs

filter' :: (a -> Bool) -> [a] -> [a]
filter' _ [] = []
filter' predicateFn (x:xs)
  | predicateFn x = x : filter' predicateFn xs
  | otherwise = filter' predicateFn xs

filter'' :: (a -> Bool) -> [a] -> [a]
filter'' p = foldr (\x acc -> if p x then x : acc else acc) []

dictGetValByKey dict key = snd . head $ filter (\(k, v) -> k == key) dict



--------------------------------------
-- TYPES
--------------------------------------

-- check type by
-- $ :t valueToCheck

-- Types are sets of values
-- Typeclasses are sets of types

-- Haskell: Typeclass <-- Type <-- Value
-- Java: Interface <-- Class <-- Object

-- explicite type annotation
-- 3 :: Double


data SimplePerson = SimplePerson String String deriving (Show)

spFirstName :: SimplePerson -> String
spFirstName (SimplePerson firstName _) = firstName

spSecondName :: SimplePerson -> String
spSecondName (SimplePerson _ secondName) = secondName

simplePersonExample = do
  let person = SimplePerson "Jan" "Kowalski"
  print person
  print $ spFirstName person
  print $ spSecondName person


data Person = Person { firstName :: String
                     , lastName :: String } deriving (Show)

introducePerson :: Person -> IO()
introducePerson p = putStrLn $ "Hi, I'am " ++ firstName p ++ " " ++ lastName p

recordExample = do
  let dude = Person "Jan" "Kowalski"
  introducePerson dude



type StrengthUnits = Int
type Warriors = [Warrior]
data Warrior =
  Sayan
  { name     :: String
  , strength :: StrengthUnits
  } |
  Human
  { name     :: String
  , strength :: StrengthUnits
  } deriving(Show)

warriorExample = do
  let vegeta = Sayan { name = "Vegeta", strength = 9001 }
  let kuririn = Human "Kuririn" 5000
  let warriors = [vegeta, kuririn]
  printWarriors warriors
  putStrLn $ "Is " ++ name vegeta ++ " strong?"
  putStrLn . show . isStrong $ vegeta

printWarriors :: Warriors -> IO ()
printWarriors = mapM_ printWarriorStats

printWarriorStats :: Warrior -> IO ()
printWarriorStats = putStrLn . getWarriorStats

getWarriorStats :: Warrior -> String
getWarriorStats w = "Name: " ++ name w ++
                    ", Strength: " ++ (show . strength $ w)

isStrong :: Warrior -> Bool
isStrong w = case over9000 . strength $ w of
  Just val -> True
  Nothing  -> False

over9000 :: StrengthUnits -> Maybe StrengthUnits
over9000 s
  | s > 9000  = Just s
  | otherwise = Nothing




newtype CustomerId = MakeCustomerId Int deriving (Show)

customerIdToInt :: CustomerId -> Int
customerIdToInt (MakeCustomerId i) = i

data Customer = MakeCustomer
  { customerId   :: CustomerId
  , customerName :: String
  , luckyNumber  :: Int
  }

customerExample :: IO ()
customerExample = do
  let henio = MakeCustomer
              { customerId = MakeCustomerId 1
              , customerName = "Henio"
              , luckyNumber = 7
              }
  putStrLn $ customerName $ henio
  putStrLn $ show $ customerId $ henio
  putStrLn $ show $ customerIdToInt $ customerId $ henio
  putStrLn $ "Lucky number: " ++ (show . luckyNumber $ henio)




rgbExample :: IO ()
rgbExample = do
    putStrLn $ show $ greenInColors

-- algebraic data type
data RGB = RGB Int Int Int

-- typeclass
-- class Eq a where
--   (==) :: a -> a -> Bool
--   (/=) :: a -> a -> Bool

-- typeclass instance
instance Eq RGB where
  -- function (==) implementation
  (RGB r1 g1 b1) == (RGB r2 g2 b2) =
    (r1 == r2) && (g1 == g2) && (b1 == b2)

instance Show RGB where
  show (RGB r g b) =
    "RGB " ++ (show r) ++ " " ++  (show g) ++ " " ++ (show b)

colors :: [RGB]
colors = [RGB 255 0 0, RGB 0 255 0, RGB 0 0 255]

green :: RGB
green = RGB 0 255 0

-- elem :: Eq a => a -> [a] -> Bool
greenInColors :: Bool
greenInColors = elem green colors



class StupidShowable a where
  stupidShow :: a -> String

instance StupidShowable Bool where
  stupidShow False = "I think this is true"
  stupidShow True  = "I think this is false"

instance StupidShowable Int where
  stupidShow i = "You gave me: " ++ show (i + 1)

instance StupidShowable (Maybe a) where
  stupidShow Nothing  = "There is something"
  stupidShow (Just _) = "There is nothing"

customTypeclassExample :: IO ()
customTypeclassExample = do
  putStrLn $ stupidShow False
  putStrLn $ stupidShow (3 :: Int)
  putStrLn $ stupidShow $ Just 3





-- () is unit (empty tuple)
-- data IO a - parametrized type

ioExample :: IO ()
ioExample = do
  -- getLine :: IO String
  line <- getLine
  putStrLn $ "You typed: " ++ line
  line <- dummyGetLine
  putStrLn line

-- return :: a -> IO a
dummyGetLine :: IO String
dummyGetLine =
  return "aaa"



-- class Functor f where
--   fmap :: (a -> b) -> f a -> f b

-- instance Functor Maybe
--   fmap f (Just x) = Just (f x)
--   fmap Nothing    = Nothing


-- class Functor f => Applicative f where
--     -- | Lift a value.
--     pure :: a -> f a
--     -- | Sequential application.
--     (<*>) :: f (a -> b) -> f a -> f b


-- class Applicative m => Monad m where
--  return :: a -> m a
--  (>>=)  :: m a -> (a -> m b) -> m b

-- Monad Examples:
-- * IO
-- * List
-- * Maybe

-- do-Notation
--
-- addM :: Monad m => m Int -> m Int -> m Int
-- addM mx my =
--   mx >>= (\x -> my >>= (\y -> return (x + y)))
--
-- addM' mx my = do
--   x <- mx
--   y <- my
--   return (x + y)

-- do-Notation is similar to JS async/await
--
-- const addM = (mx, my) =>
--   mx.then(x => my.then(y => x + y))
--
-- async function addM(mx, my) {
--   const x = await mx
--   const y = await my
--   return x + y
-- }






