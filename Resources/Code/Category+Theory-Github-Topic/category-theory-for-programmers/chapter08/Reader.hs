class Functor' f where
    fmap' :: (a -> b) -> f a -> f b
class Contravariant' f where
    fmap' :: (b -> a) -> f a -> f b

type Reader r a = r -> a
instance Functor' (Reader r) where
    -- fmap' :: (a -> b) -> (r -> a) -> (r -> b)
    fmap f rx = f . rx -- \x -> f (rx x), if \x has type r

type Op r a = a -> r
instance Contravariant' (Op r) where
    -- fmap' :: (b -> a) -> (a -> r) -> (b -> r)
    fmap' f ox = ox . f -- types align pretty well here