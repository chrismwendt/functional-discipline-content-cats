module HAD.Y2014.M04.D02.Exercise where
import Data.List

-- DAY 2
-- | update update the nth element of a list
-- if the index is not a valid index, it leaves the list unchanged
--
-- Examples
--
-- >>> update (-2) 10 [0..4]
-- [0,1,2,3,4]
--
-- >>> update 6 10 [0..4]
-- [0,1,2,3,4]
--
-- >>> update 2 10 [0..4]
-- [0,1,10,3,4]
--
update :: Eq a => Int -> a -> [a] -> [a]
update i v xs = map (\x -> if ((elemIndex x xs) == Just i) then v else x) xs

-- DAY 3
-- | foo
-- Types. Powerful enough to get it right.
--
foo1 :: (a ->  b) -> [a] -> [(a,b)]
foo1 f xs = map (\x -> (x, f x)) xs 

foo2 :: (a ->  b) -> [a] -> [(a,b)]
foo2 f xs = [(x, f x) | x <- xs] 

-- DAY 4
{- | braid
   Braid two lists
   Examples:
   >>> braid [0,2] [1,3]
   [0,1,2,3]
   >>> braid [0,2] [1,3 ..] 
   [0,1,2,3]
   >>> braid [0,2 ..] [1,3]
   [0,1,2,3]
-}
braid :: Eq a => [a] -> [a] -> [a]
braid  xs ys = foldl' (?) [] zs
    where
        a ? (x, y) = if (x==y) then a ++ [x] else a ++ [x,y]
        zs = zip xs ys
