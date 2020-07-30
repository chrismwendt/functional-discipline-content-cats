# 2019_Q2_Cat4Programmers_Monoid

Dada as definições da classe Monoid em Haskell/C++/Python:

```haskell
class Monoid m where
    mempty  :: m
    mappend :: m -> m -> m
```

```cpp
// compile no g++-8 com -fconcepts -std=c++2a
template<class T>
  T mempty = delete;

template<class T>
  T mappend(T, T) = delete;

template<class M>
  concept bool Monoid = requires (M m) {
    { mempty<M> } -> M;
    { mappend(m, m); } -> M;
  };
```

```python
from functools import singledispatch

@singledispatch
def mempty(a):
    raise Error("Not implemented for" + a)

@singledispatch
def mappend(a, b):
    raise Error("Not implemented for" + a)
```

E as instâncias de inteiros com multiplicação:

```haskell
instance Monoid Int where
    mempty  = 1
    mappend = (*)
```

```cpp
template<>
int mempty<int> = {1};

int mappend(int x, int y) {
    return x*y;
}
```

```python
@mempty.register(int)
def _(a):
    return 1

@mappend.register(int)
def _(a,b):
    return a * b
```

Pense e implemente outros tipos em uma dessas linguagens que também pertencem a classe Monoid.
