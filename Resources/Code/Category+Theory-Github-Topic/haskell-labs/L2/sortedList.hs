module SortedList where
import Data.List


data SList a = Nil | Slist a (SList a)
    deriving (Show, Eq)


slist :: (Ord a) => [a] -> SList a
slist [] = Nil
slist xs = _slist_help $ sort xs


-- Helper to not sort every time
_slist_help :: (Ord a) => [a] -> SList a
_slist_help [] = Nil
_slist_help xs = Slist (head xs) (slist (tail xs))


tolist :: (Ord a) => SList a -> [a]
tolist Nil = []
tolist (Slist x xs) = [x] ++ tolist xs


sappend :: (Ord a) => SList a -> a -> SList a
sappend Nil x = Slist x Nil
sappend l@(Slist x xs) y 
    | x < y = Slist x (sappend xs y)
    | otherwise = Slist y l


sconcat :: (Ord a) => SList a -> SList a -> SList a
sconcat Nil xs = xs
sconcat xs Nil = xs
sconcat xs ys = slist $ (tolist xs) ++ (tolist ys)


spop :: (Ord a) => SList a -> SList a 
spop Nil = Nil
spop xs = slist $ init $ tolist xs


smap :: (Ord a) => (a -> a) -> SList a -> SList a
smap _ Nil = Nil
smap f xs = slist $ map f (tolist xs)


sfilter :: (Ord a) => (a -> Bool) -> SList a -> SList a
sfilter _ Nil = Nil
sfilter f xs = slist $ filter f (tolist xs)
