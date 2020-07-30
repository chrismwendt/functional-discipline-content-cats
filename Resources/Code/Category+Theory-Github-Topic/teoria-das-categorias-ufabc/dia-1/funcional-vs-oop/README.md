# Dado o tipo soma definido em Haskell:

```haskell
data Shape = Circle Float
           | Rect Float Float
```

podemos definir uma função genérica `area`:

```haskell
area :: Shape -> Float
area (Circle r) = pi * r * r
area (Rect d h) = d * h
```

1. **Implemente a estrutura `Shape` como um `interface` na sua linguagem OOP favorita! Compare a quantidade de linhas de código.**

Podemos acrescentar uma função para calcular circunferência das formas no Haskell:

```haskell
circ :: Shape -> Float
circ (Circle r) = 2.0 * pi * r
circ (Rect d h) = 2.0 * (d + h)
```

2. **Acrescente essa função na `interface` criada no exercício anterior. Marque as linhas de código que você teve que alterar.**

3. **Adicione a forma `Square` tanto no tipo `Shape` do Haskell como na `interface` implementada por você. O que teve que ser feito em Haskell e na sua linguagem favorita?**

Para facilitar, utilize o código em Haskell no Repl.it: https://repl.it/@folivetti/NeighboringEnormousInfo
