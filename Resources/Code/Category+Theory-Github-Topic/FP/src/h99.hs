-- https://wiki.haskell.org/99_questions


q1 = do
  (lastElOfList' [1,2,3]) == 3

lastElOfList :: [a] -> a
lastElOfList [] = error "empty list"
lastElOfList [x] = x
lastElOfList (_:xs) = lastElOfList xs

lastElOfList' xs = xs !! (length xs - 1)


q2 = do
  (lastButOneElOfList [1,2,3,4]) == 3

lastButOneElOfList :: [a] -> a
lastButOneElOfList [] = error "empty list"
lastButOneElOfList [x] = error "only one el"
lastButOneElOfList (x:xs) =
                   if length xs == 1 then x
                   else lastButOneElOfList xs

q3 = do
  (elAt "abcdef" 3) == 'c'

elAt :: [a] -> Int -> a
elAt xs idx = xs !! (idx - 1)


q4 = do
  length'' "abcdef" == 6

length' :: [a] -> Int
length' [] = 0
length' [x] = 1
length' (x:xs) = 1 + length' xs

length'' :: [a] -> Int
length'' xs = foldl (\acc x -> acc + 1) 0 xs


q5 = do
  (reverse' "abcd") == "dcba"

reverse' :: [a] -> [a]
reverse' xs = foldl (\acc x -> x:acc) [] xs

q6 = do
  isPalindrome "kajak" == True

isPalindrome :: (Eq a) => [a] -> Bool
isPalindrome xs = (reverse xs) == xs