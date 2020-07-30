# Escreva o operador de composição da categoria Writer na sua linguagem favorita (ou segunda favorita).

Relembrando a implementação da composição do tipo `Writer` em Haskell e C++:

```haskell
(>=>) :: (a -> Writer b) -> (b -> Writer c) -> (a -> Writer c)
m1 >=> m2 = \a ->
    let (b, s1) = m1 a
        (c, s2) = m2 b
    in (c, s1 ++ s2)
```

```cpp
auto const compose = [](auto m1, auto m2) {
    return [m1, m2](auto a) {
        auto p1 = m1(a);
        auto p2 = m2(p1.first);
        return make_pair(p2.first, p1.second + p2.second);
    };
};
```

Implemente essa definição em outra linguagem. Construa um exemplo completo de utilização.
