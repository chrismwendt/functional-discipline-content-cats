# 4. Implemente um Functor Representável para uma árvore de jogos

Uma árvore de estados de jogos pode ser representada como uma *Rose Tree*:

```haskell
data GameTree m a = Node a [GameTree m a]
```

Em que o elemento `a` representa o nó atual e a lista representa seus filhos. O tipo `m` representa os movimentos possíveis do jogo e devem ser enumeráveis e finitos. O tipo `a` representa a estrutura de dados contendo a informação do estado do jogo.

Para exemplificar, vamos construir as regras do jogo [8-puzzle](https://blog.goodaudience.com/solving-8-puzzle-using-a-algorithm-7b509c331288), que consiste em um quadriculado de dimensões $3 \times 3$, contendo um elemento vazio e cujo objetivo é de ordenar os quadriculados na sequência numérica.

A representação de um estado do nosso jogo e os movimentos podem ser definidas com as seguintes estruturas:

```Haskell
-- Posso mover o quadrado vazio para qualquer direçao
data Moves = LFT | RGT | UP | DOWN deriving (Show, Enum, Bounded)

-- Estado contendo a coordenada da peça vazia
-- e a matriz da permutação atual
data State = S { zeroX :: Int
               , zeroY :: Int
               , board :: [[Int]]
               } deriving Show
```
No código-modelo temos também todas as funções auxiliares necessárias para criar novos estados.

Com a definição da classe de Functors Representáveis:

```Haskell
class Representable f where
   type Rep f :: *
   tabulate :: (Rep f -> x) -> f x
   index    :: f x -> Rep f -> x
```

Complete as definições para uma instância de `GameTree m`:

```Haskell
instance (Bounded m, Enum m) => Representable (GameTree m) where
    type Rep (GameTree m) = ??a??

    -- :: (Rep Tree -> State) -> Tree State
    -- a lista de filhos da arvore é a aplicação cumulativa de 
    -- cada possível movimento 
    tabulate f = Node ??b??   [tabulate (??c??) | mv <- [minBound .. maxBound]]   -- a arvore eh formada pelo estado inicial e a lista da aplicacao de tabulate para cada movimento possivel

    -- :: Tree State -> Rep Tree -> State
    -- simplesmente percorre as ramificações 
    -- seguindo os movimentos executados
    index (Node x ts) []       = x   -- nao tenho mais acoes pra fazer
    index (Node x ts) (mv:mvs) = ??d?? -- aplico recursivamente index no filho correspondente ao movimento mv
```

para que, dada uma árvore `gameT = `, possamos recuperar um estado qualquer fazendo `index gameT [LFT, UP, UP]`, por exemplo.

Para isso, responda as seguintes perguntas:

a. Qual o tipo `Rep (GameTree m)`? (dica: é o parâmetro de uma das funções)
b. Sendo `f` uma função que recebe uma lista de movimentos e aplica sequencialmente partindo do estado inicial, como eu recupero o estado inicial?
c. Na chamada recursiva de tabulate devo compor a função `f` com o que?
d. Qual posição na minha lista de nós-filhos corresponde ao movimento `mv`?

Caso não queira instalar um compilador do Haskell, pode utilizar o [repl.it](https://repl.it/languages/haskell)

Notas:
- As funções `minBound, maxBound` retornam o menor e maior valor do tipo `m`, respectivamente.
- A função `fromEnum` retorna o equivalente numrérico para o tipo `m`. Exemplo: `fromEnum LFT = 0` e `fromEnum DOWN = 3`
- O i-ésimo elemento de uma lista no Haskell é acessado com `lista !! i`.
