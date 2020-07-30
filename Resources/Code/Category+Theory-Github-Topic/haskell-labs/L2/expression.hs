module Expression where


data Exp a = Nil
    | Term a
    | Add (Exp a) (Exp a)
    | Dif (Exp a) (Exp a)
    | Mltply (Exp a) (Exp a)
    | Div (Exp a) (Exp a)
    | Minus (Exp a) 
    | EXP (Exp a)
    deriving Show

eval :: Exp Double -> Double
eval Nil = 0
eval (Term x) = x
eval (Minus x) = -1.0 * eval x
eval (Add x y) = (eval x) + (eval y)
eval (Dif x y) = (eval x) - (eval y)
eval (Mltply x y) = (eval x) * (eval y)
eval (Div x y) = (eval x) / (eval y)
eval (EXP x) = exp $ eval x


exp1 = Add (Term 2.0) (Mltply (Term 3.0) (Term 4.0))
t = Term 4.0
q = Term 2.0

