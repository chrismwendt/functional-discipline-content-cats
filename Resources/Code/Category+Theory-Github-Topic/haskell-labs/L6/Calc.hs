module Calc ( main ) where

import System.IO
import Text.Read                ( readMaybe )
import Data.List.Split          ( splitOn )
import Control.Monad.State.Lazy

-- Simple calculator for evaluating an input in 
-- form of the polish notation. Uses the State Monad.

-- STACK

type Stack = 
  State [String] 


showStack :: Stack a -> [String]
showStack s = snd $ runState s []


push :: String -> Stack ()
push s = state $ \stack -> ((), s : stack)


pop :: Stack (Maybe String)
pop = state $ \s -> 
  case s of
    [] -> (Nothing, [])
    (x:xs) -> (Just x, xs)
      
-- CALCULATOR

evalHelp :: Maybe Int -> Maybe Int -> Maybe String -> Maybe Int
evalHelp (Just a) (Just b) (Just s)
  | s == "+" = Just $ a + b
  | s == "*" = Just $ a * b
  | s == "-" = Just $ a - b
  | otherwise = Nothing
evalHelp _ _ _ = Nothing


evaluate :: Stack () -> Stack ()
evaluate stack = stack >> do
  x <- pop 
  y <- pop
  c <- pop

  let a = x >>= \d -> (readMaybe d :: Maybe Int) >>= return
  let b = y >>= \d -> (readMaybe d :: Maybe Int) >>= return

  case (evalHelp a b c) of
    Nothing -> stack
    Just v -> evaluate $ push $ show v


listToStack :: [String] -> Stack ()
listToStack xs = foldl (>>) (push y) [push x | x <- ys]
    where
      (y:ys) = reverse xs

      
sentenceToStack :: String -> Stack ()
sentenceToStack xs = listToStack $ splitOn " " xs

-- MAIN

main :: IO ()
main = 
  putStrLn "Write some expression like '5 4 +' ." >>
  getLine >>= print . showStack . evaluate . sentenceToStack

