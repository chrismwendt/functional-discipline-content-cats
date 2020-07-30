-- #I9
-- Implementaion of unary number with two show options
data Numb = Zero | Succ Numb 

showNumber :: Numb -> Integer
showNumber Zero = 0
showNumber (Succ x) = 1 + showNumber x

-- instance Show Numb where
--     show Zero = show 0
--     show n = show $ showNumber n

showUnary :: Numb -> String
showUnary Zero = ""
showUnary (Succ x) = "0" ++ showUnary x

instance Show Numb where
    show Zero = show 0
    show n = show $ showUnary n


n = Succ (Succ (Succ Zero))