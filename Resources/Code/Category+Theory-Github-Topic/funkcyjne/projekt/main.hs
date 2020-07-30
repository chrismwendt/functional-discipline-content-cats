import System.IO  
import Control.Monad
import System.Environment ( getArgs )
import Data.Char
import Data.List
import Data.Function
import Control.Arrow

-- uruchamiane jako "main.exe [liczba słów do wypisania] [plik ze stopami] [plik do analizy 1] [plik do analizy 2] ..."
-- przykładowo .\main.exe 20 .\data\stop.words .\data\eg1.txt .\data\eg2.txt .\data\eg3.txt .\data\tobe.txt > wyniki
-- z tablicy z listami słów można utworzyć word cloud np. tutaj: https://worditout.com/word-cloud/create
-- wybierając opcję "Table", traktując wyprintowany kod kawałkiem prostego js'a, np. [/*tablica z wynikami*/].join('\n') 
-- i wklejając go tam. Wynik tego możemy zobaczyć w pliku ./eg_wordcloud.png 

data Stat = Stat { number :: Int 
                 , name :: String
                 }

instance Show Stat where
    show (Stat n m) = "\"" ++ (id m) ++ " " ++ (show n) ++ "\""

instance Eq Stat where
    x == y = (name x) == (name y)

instance Ord Stat where
    compare x y = compare (number x) (number y)

main = do
    args <- getArgs
    let number = read $ head args :: Int
    stops <- readFile (head.tail $ args)
    let contents = map readFile (tail.tail $ args)
    let stats = map (\ x -> take number . frequency . (filterStop . words $ stops) . clear . words <$> x) contents
    print $ tail.tail $ args
    mapM (>>= print) (map (\x -> (length.words <$> x)) contents)
    mapM (>>= print) stats
    mapM (>>= print) [jaccard <$> s1 <*> s2 | s1 <- stats, s2 <- stats]

clear :: [String] -> [String]
clear s = map (map toLower) $ filter (all (\ y -> y `elem` ['a' .. 'z'])) s

filterStop :: [String] -> [String] -> [String]
filterStop w = filter (`notElem` w)

frequency :: [String] -> [Stat]
frequency s = map (\(x, y) -> Stat x y) $ sortBy (flip compare `on` fst) $ map (length Control.Arrow.&&& head) $ group.sort $ s

jaccard :: [Stat] -> [Stat] -> Double
jaccard stats1 stats2 = fromIntegral (sum (map(\ x -> intersection (find (== x) stats2) x) stats1))/fromIntegral (sum (map (\ x -> statUnion (find (== x) stats2) x) stats1))

intersection :: Maybe Stat -> Stat -> Int
intersection Nothing x = 0
intersection (Just x) y = if x < y then number x else number y

statUnion :: Maybe Stat -> Stat -> Int
statUnion Nothing x = number x
statUnion (Just x) y = if x > y then number x else number y