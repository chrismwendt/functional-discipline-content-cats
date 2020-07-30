# Implemente o tipo `Either` na sua segunda linguagem favorita (a primeira sendo o Haskell). Teste implementando o tipo Maybe.

O tipo `Either` em Haskell é definida como (seguida de um exemplo de uso):

```haskell
data Either a b = Left a | Left b

safeDiv :: Int -> Int -> Either () Int
safeDiv x 0 = Left ()  -- erro de div
safeDiv x y = Right (x `quot` y)
```
