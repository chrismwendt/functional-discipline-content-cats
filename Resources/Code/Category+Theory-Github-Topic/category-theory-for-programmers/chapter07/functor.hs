-- basic functors

class Functor' f where
    fmap' :: (a -> b) -> f a -> f b

instance Functor' Maybe where
    fmap' f maybe = case maybe of
        Nothing -> Nothing
        Just x -> Just (f x)

x :: String
x = "This is a string"
f :: String -> String
f x = x ++ " mapped"

data List a = Nil | Cons a (List a)
instance Show a => Show (List a) where
    show list = case list of
        Nil -> ""
        Cons x Nil -> show x ++ ""
        Cons x y -> show x ++ ", " ++ show y
instance Functor' List where
    fmap' f list = case list of
        Nil -> Nil
        Cons x y -> Cons (f x) (fmap' f y)
list :: List String
list = Cons "first" (Cons "second" Nil)

main :: IO ()
main = do
    print $ fmap' f (Just x)
    print $ fmap' f list
    print misSquared
    print misSquared2


-- composition of functors

square :: Int -> Int
square x = x * x

mis = Just (Cons 1 (Cons 2 (Cons 3 Nil)))

misSquared = fmap' (fmap' square) mis
misSquared2 = (fmap' . fmap') square mis