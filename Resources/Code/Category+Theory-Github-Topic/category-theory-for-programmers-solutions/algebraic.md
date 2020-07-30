## 1) `Maybe a` and `Either () a` isomorphisms:

```hs
data Maybe a = Nothing | Just a
data Either a b = Left a | Right B

data Either () a = Left () | Right a

factorize :: Maybe a -> Either () a
factorize Nothing = Left ()
factorize Just a = Right a

factorize_inv :: Either () a -> Maybe a
factorize_inv Left () = Nothing
factorize_inv Right a = Just a
```

## 5) Prove `a + a = 2 * a`

```
a + a = 2 * a
a + a = (Bool, a)
a + a = (True, a) | (False, a)
```


