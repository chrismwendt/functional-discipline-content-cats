class Bifunctor f where
    bimap :: (a -> c) -> (b -> d) -> f a b -> f c d
    bimap g h = first g . second h
    first :: (a -> c) -> f a b -> f c b
    first g = bimap g id
    second:: (b -> d) -> f a b -> f a d
    second h = bimap id h

newtype BiComp bf fu gu a b = BiComp (bf (fu a) (gu b))
-- BiComp bf fu gu takes two types -> it's a bifunctor
instance (Bifunctor bf, Functor fu, Functor gu) => Bifunctor (BiComp bf fu gu) where
    bimap g h (BiComp x) = BiComp ()