module Geometry where

data Point = Point{ 
    x :: Double, 
    y :: Double
    }   deriving Show

data Figure = Rectangle {
        a :: Point,
        l :: Double,
        h :: Double
    }
    | Disc {
        a :: Point,
        r :: Double
    }
    | Line {
        a :: Point,
        b :: Point
    } deriving Show

dim :: Figure -> Integer
dim (Line _ _) = 1
dim _ = 2

field :: Figure -> Double
field (Line _ _) = 0
field (Rectangle a b c) = b * c
field (Disc a r) = pi * r^2 

dir :: Point -> Point -> (Double, Double)
dir a b = ((x b) - (x a), (y b) - (y a))

scale :: Figure -> Double -> Figure
scale (Disc a r) s = Disc a (s*r)
scale (Rectangle a l h) s = Rectangle a (s*l) (s*h)
scale (Line a b) s = Line a nb
    where
        (l, h) = dir a b
        nb = Point ((x b) + (s-1) * l)  ((y b) + (s-1) * h) 
