module BST (
    Bst, contains, add, search, 
    leaves, remove, t) 
    where 

import Data.List

data Bst a = Nil 
            | Node a (Bst a) (Bst a)
            deriving (Show, Eq)


contains :: (Ord a) => Bst a -> a -> Bool
contains Nil _ = False
contains (Node x left right) y
    | x == y = True
    | x < y = contains right y
    | x > y = contains left y


addHelp :: (Ord a) => Bst a -> a -> (Bst a, Bool)
addHelp Nil x = (Node x Nil Nil, True)
addHelp n@(Node x left right) y 
    | x == y = (n, False)
    | y < x = (Node x nl right, sl)
    | y > x = (Node x left nr, sr)
    where 
        (nl, sl) = addHelp left y
        (nr, sr) = addHelp right y


add :: (Ord a) => Bst a -> a -> Bst a
add t = fst . addHelp t


-- this is probably being executed when called
-- so lazy eval magic does not work and
-- (contains test 4) kills the ghci
-- test = foldl add Nil [1,4 ..]


-- Returns a node if it exist in tree
search :: (Ord a) => Bst a -> a -> Bst a
search Nil _ = Nil
search n@(Node x left right) y
    | x == y = n
    | y > x = search right y
    | y < x = search left y


-- Returns list of node's leaves
leaves :: (Ord a) => Bst a -> [a]
leaves Nil = []
leaves (Node x Nil Nil) = [x]
leaves (Node _ left right) = (leaves left) ++ (leaves right)


-- Check node's type and remove it in a proer way
removeMagic :: (Ord a) => Bst a -> Bst a
removeMagic Nil = Nil
removeMagic (Node _ Nil Nil) = Nil -- remove leaf
removeMagic (Node _ Nil right ) = right -- remove connector
removeMagic (Node _ left Nil) = left -- remove connector
removeMagic (Node x left right) = Node succ left nr
    where
        succ = head $ sort $ leaves right
        nr = remove right succ


-- Removes node from bst tree
remove :: (Ord a) => Bst a -> a -> Bst a
remove Nil _ = Nil
remove n@(Node x left right) y 
    | y < x = Node x (remove left y) right
    | y > x = Node x left (remove right y)
    | y == x = removeMagic n 


-- sample tree
t = Node 4 (Node 2 (Node 1 Nil Nil) Nil) (Node 10 (Node 7 Nil Nil) (Node 12 (Node 11 Nil Nil) (Node 13 Nil Nil)))
