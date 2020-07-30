module DataType 
import Data.Vect
%default total

data Expr : Type where
  Bind : String ->Expr
  Plus : Expr->Expr->Expr
  Cst : Double->Expr -- constant
  
expr1 : Expr  
expr1 = Plus (Cst 3) $ Bind "x"

expr2 : Expr  
expr2 = Plus (Cst 2) $ Plus (Cst 3) $ Bind "x"

expr3 : Expr  
expr3 = Plus (Bind "x") $ Plus (Cst 3) $ Bind "x"

expr4 : Expr  
expr4 = Plus (Bind "y") $ Plus (Cst 3) $ Bind "x"
 
numericDf : (Double->Double) -> Double ->Double
numericDf f x = ((f $ x+0.1) - f x )/0.1

--expression,varname
exp2f : Expr->String -> (Double->Double)
exp2f (Bind x) y = if (x==y) then (\x=>x) else (\_=>1.0)--err
exp2f (Plus x z) y = (\arg=>((exp2f x y) arg)*((exp2f z y) arg))
exp2f (Cst x) y = \_=>x


exp2vf : Expr->Vect n String -> (Vect n Double->Double)
exp2vf x [] _ =  1
exp2vf a (y :: xs) (z :: ys)= exp2f a y $ exp2vf a xs ys

-- f , x , x value
numericDiffExpr : Expr -> String -> Double -> Double
numericDiffExpr x y z = numericDf (exp2f x y) z


data Exp : Type->Type where
  Vf : Int->Exp a
  Adf : a -> a -> Exp a

Functor Exp where
  map func (Vf x) = Vf x
  map f (Adf x y) = Adf (f x) $ f y
  
e1 : Exp Int
e1 = Vf 1 -- Adf (Vf 1) (Vf 2)


isNil11 : List a -> Bool
isNil11 [] = True
isNil11 (x :: xs) = False

l1isNil11 : (\x=>True) Prelude.List.Nil = True
l1isNil11 = Refl


 

