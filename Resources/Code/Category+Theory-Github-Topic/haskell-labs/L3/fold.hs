module Folds where


myFoldl :: (b-> a -> b) -> b -> [a] -> b
myFoldl _ d [] = d
myFoldl f d (x:xs) = myFoldl f (f d x) xs

testMyFoldl = myFoldl (\x y -> concat ["(",x,"+",y,")"]) "0" (map show [1..13])


myFoldl' :: (b-> a -> b) -> b -> [a] -> b
myFoldl' _ d [] = d
myFoldl' f d (x:xs) = myFoldl' f ( 0 `seq` (f d x)) xs

testMyFoldl' = myFoldl' (\x y -> concat ["(",x,"+",y,")"]) "0" (map show [1..13])


myFoldr :: (a-> b -> b) -> b -> [a] -> b
myFoldr _ d [] = d
myFoldr f d (x:xs) = f x (myFoldr f d xs)

testMyFoldr = myFoldr (\x y -> concat ["(",x,"+",y,")"]) "0" (map show [1..13])

