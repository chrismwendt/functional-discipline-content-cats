module Prob 
-- http://mlg.eng.cam.ac.uk/pub/pdf/SciGhaGor15.pdf
data Dist : Type -> Type where
  Return      : a -> Dist a
  Bind        : Dist b -> (b -> Dist a) -> Dist a
--  Primitive   : Sampleable d => d a -> Dist a
--  Conditional : (a -> Prob) -> Dist a -> Dist a

Functor Dist where
  map f (Return x) = Return (f x)
  map f (Bind x g) = Bind x (\b=>map f $ g b)

Applicative Dist where  
  
  pure x = Return x
  (<*>) (Return x) (Return y) = Return (x y)
  (<*>) (Return x) (Bind y f) = Return (x ?Applicative_rhs_7)
  (<*>) (Bind x f) (Return y) = Return ?Applicative_rhs_2
  (<*>) (Bind x f) (Bind y g) = Return ?Applicative_rhs_6
  
Monad Dist where
  (>>=) = Bind
  join x = ?Monad_rhs_2
