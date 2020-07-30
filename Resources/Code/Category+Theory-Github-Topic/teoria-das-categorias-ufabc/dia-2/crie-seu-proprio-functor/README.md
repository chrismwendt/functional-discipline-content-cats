# 1. Defina as instâncias dos Functors Const, Identity, Lista, Maybe, Writer, Reader em qualquer linguagem de programação, exceto Haskell.

Lembrando que uma instância de Functor deve implementar:

```Haskell
fmap :: (a -> b) -> F a -> F b
```

Implemente da melhor forma para a linguagem escolhida, tanto um `fmap` retornando uma função `F a -> F b` ou como recebendo uma função e um elemento e retornando `F b`.
