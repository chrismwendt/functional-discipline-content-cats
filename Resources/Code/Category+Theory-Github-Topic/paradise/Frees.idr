module Frees

import Control.Monad.Freer
import Debug.Trace
import Control.Monad.State
import Control.Monad.Writer
import System
data Tensor : Type where
  DoubleT : Double -> Tensor

implementation Show Tensor where
  show (DoubleT x) = show x

data GraphData : Type -> Type where 
  Mul : Tensor -> Tensor -> GraphData Tensor
  Placeholder : GraphData Tensor
  Constant : Double -> GraphData Tensor

FreeGraph : Type --type of computation graph ,freer graph
FreeGraph = Freer GraphData Tensor

mulG : FreeGraph
mulG = do
  x<-liftF $ Constant 2
  y<-liftF $ Constant 3
  liftF $ Mul x y

st : State String Int
st = ST (\str => Id (1, str++"1,"))

stm : State String Int
stm = do
  st
  st

free2state : {x : Type} -> GraphData x -> State String x
free2state (Mul (DoubleT x) (DoubleT y)) = ST (\str => Id (DoubleT $ x*y, str++"mul"))
free2state Placeholder = ST (\str => Id (DoubleT $ 0.0, str++"Placeholder,"))
free2state (Constant x) = ST (\str => Id (DoubleT $ x, str++"Constant,"))

free2li : {x : Type} -> GraphData x -> List x
free2li (Mul (DoubleT x) (DoubleT y)) = pure $ DoubleT $ x*y
free2li Placeholder = pure $ DoubleT 1
free2li (Constant x) = [DoubleT 1,DoubleT x]

free2w : {x : Type} -> GraphData x -> Writer String x
free2w (Mul (DoubleT x) (DoubleT y)) = do
  tell "(Mul (DoubleT x) (DoubleT y))"
  pure $ DoubleT $ x*y
free2w Placeholder = do
  tell "Placeholder"
  pure $ DoubleT 1
free2w (Constant x) = do
  tell "(Constant x)"
  pure $ DoubleT x

f2st : State String Tensor
f2st = foldFreer free2state mulG

data Sess : Type where
  Loginfo : String->String->Sess
  
data SessData : Type -> Type where 
  GetSess : SessData Sess

SessGraph : Type --type of computation graph ,freer graph
SessGraph = Freer SessData Sess

implicit liftd : SessData Sess -> SessGraph
liftd = liftF

sess1 : SessGraph
sess1 = do
  x<-GetSess
  GetSess
