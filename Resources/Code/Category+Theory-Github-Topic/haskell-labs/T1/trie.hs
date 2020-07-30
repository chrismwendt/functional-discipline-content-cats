import Data.List

data Alfabet = Empty | A | B | C deriving (Show, Eq, Ord, Enum)

data Trie = Nil
            | Node {
                var :: Bool,
                getA :: Trie,
                getB :: Trie,
                getC :: Trie
            } deriving (Eq)


-- Check if a trie contains a word
contains :: Trie -> [Alfabet] -> Bool
contains Nil _ = False
contains  t@(Node v a b c) [] = v
contains t@(Node v a b c) (x:xs)
    | x == A && a /= Nil = contains a xs
    | x == B && b /= Nil = contains b xs
    | x == C && c /= Nil = contains c xs
    | otherwise = False


-- Helper for Show instance, returns list of words in a trie
getWords :: Trie -> [Alfabet] -> Alfabet -> [[Alfabet]]
getWords Nil _ _ = []
getWords t@(Node v a b c) _ Empty
    | v = [[]] ++ (getWords a [] A) ++ (getWords b [] B) ++ (getWords c [] C)
    | otherwise = (getWords a [] A) ++ (getWords b [] B) ++ (getWords c [] C)
getWords t@(Node v a b c) ls m
    | v = [letters] ++ r
    | otherwise = r
    where
        letters = ls ++ [m]
        r = (getWords a letters A) ++ (getWords b letters B) ++ (getWords c letters C)


instance Show Trie where
    show Nil = []
    show t = show $ sort $ getWords t [] Empty


add :: Trie -> [Alfabet] -> Trie
add Nil [] = Node True Nil Nil Nil -- add empty word
add Nil xs = add (Node False Nil Nil Nil) xs
add t@(Node v a b c) [] = Node True a b c -- add empty word
add t@(Node v a b c) (x:xs)
    -- Node does not exists
    | x == A  && a == Nil && xs == [] =  Node v (Node True Nil Nil Nil) b c
    | x == A  && a == Nil =  Node v (add (Node False Nil Nil Nil) xs) b c 
    | x == B  && b == Nil && xs == [] = Node v a (Node True Nil Nil Nil) c
    | x == B  && b == Nil =  Node v a (add (Node False Nil Nil Nil) xs) c
    | x == C  && c == Nil && xs == [] =  Node v a b (Node True Nil Nil Nil)
    | x == C  && c == Nil =  Node v a b (add (Node False Nil Nil Nil) xs)
    -- Node exists
    | x == A && xs == [] = Node v (Node True (getA a) (getB a) (getC a)) b c
    | x == B && xs == [] =  Node v a (Node True (getA b) (getB b) (getC b)) c
    | x == C && xs == [] =  Node v a b (Node True (getA c) (getB c) (getC c))
    | x == A = Node v (add a xs) b c
    | x == B =  Node v a (add b xs) c
    | x == C =  Node v a b (add c xs)

    
-- A* B
infTrie :: Trie
infTrie = foldl' (\x y -> add x ((take y as) ++ [B])) Nil [0,1 ..]
    where
        as = [A, A ..]

test = Node False (Node False (Node True Nil Nil Nil) Nil Nil) (Node True Nil Nil Nil) (Node True Nil (Node True Nil Nil Nil) Nil)
test2  = add (add Nil [A, B]) [A, A, B, C]
-- test3 = contains infTrie [A,A,A,B] -- does not work :<
