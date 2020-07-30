## State monad

```haskell
newtype State s a = State { runState :: s -> (a, s) }


state :: (s -> (a, s)) -> State s a


return :: a -> State s a
return x = state ( \ s -> (x, s) )


(>>=) :: State s a -> (a -> State s b) -> State s b
p >>= k = q where
    p' = runState p        -- p' :: s -> (a, s)
    k' = runState . k      -- k' :: a -> s -> (b, s)
    q' s0 = (y, s2) where  -- q' :: s -> (b, s)
        (x, s1) = p' s0    -- (x, s1) :: (a, s)
        (y, s2) = k' x s1  -- (y, s2) :: (b, s)
    q = state q'


put :: s -> m ()
put newState = state $ \_ -> ((), newState)


get :: m s
get = state $ \s -> (s, s)


evalState :: State s a -> s -> a
evalState p s = fst (runState p s)


execState :: State s a -> s -> s
execState p s = snd (runState p s)

```


### Worth reading:

https://wiki.haskell.org/Monad

http://hackage.haskell.org/package/mtl-2.2.2/docs/Control-Monad-State-Lazy.html

https://en.wikibooks.org/wiki/Haskell/Understanding_monads/State

https://mmhaskell.com/monads-5