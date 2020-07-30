# Implemente os Zippers de lista e árvore binária em sua linguagem favorita (exceto Haskell).

Relembrando o Zipper de lista em Haskell:

```haskell
data Zipper a = Zip [a] [a]

criaZip :: [a] -> Zipper a
criaZip xs = Zip [] xs

esq :: Zipper a -> Zipper a
esq (Zip []     ds) = Zip [] ds
esq (Zip (e:es) ds) = Zip es (e:ds)

dir :: Zipper a -> Zipper a
dir (Zip es [])     = Zip es []
dir (Zip es (d:ds)) = Zip (d:es) ds
```

e o Zipper de árvore:

```haskell
data Zipper a = Zip { left  :: Tree a
                    , right :: Tree a
                    , focus :: [Either (a, Tree a) (a, Tree a)]
                    }
                    
criaZip :: Tree a -> Zipper a
criaZip Empty = Zip Empty Empty []
-- Foco inicial não tem ninguém acima dele (Empty)
criaZip (Node l x r) = Zip l r [Left (x, Empty)]

esq :: Zipper a -> Zipper a
esq tz = 
  case left tz of
    Empty      -> tz  -- se não temos nós a esquerda
    -- Caso contrario, o novo foco é o nó raiz da árvore esquerda
    -- acima dele é a árvore direita
    Node l x r -> Zip l r (Left (x, (right tz)) : focus tz)
       
dir :: Zipper a -> Zipper a
dir tz = 
  case right tz of
    Empty      -> tz
    Node l x r -> Zip l r (Right (x, (left tz)) : focus tz)
    
upwards :: Zipper a -> Zipper a
upwards (Zip l r [])     = Zip l r []
upwards (Zip l r [x])    = Zip l r [x]
upwards (Zip l r (f:fs)) = t
  where t = case f of
              Left  (x, t') -> Zip (Node l x r) t' fs              
              Right (x, t') -> Zip t' (Node l x r) fs
```
