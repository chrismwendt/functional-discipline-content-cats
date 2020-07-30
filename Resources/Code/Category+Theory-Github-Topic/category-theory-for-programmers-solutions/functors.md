## 1) Maybe functor of `fmap _ _ = Nothing`?

Claim: `fmap id m = id m`

For `Nothing`

```hs
fmap id m == fmap id Nothing {- by m expansion -}
          == Nothing         {- by fmap defn -}
```

For `Just a`

```hs
fmap id m == fmap id (Just a) {- by m expansion -}
          == Nothing          {- by fmap defn -}
```

So the claim is fake.

## 2) Prove functor laws for the reader functor

Claim `fmap id m = id m`

```hs
fmap id m == fmap id ((->) r) {- by m expansion -}
          == id . ((->) r)    {- by fmap defn -}
          == (.) id ((->) r)  {- by expansion of . -}
          == ((->) r)         {- identity element composition -}

          == id ((->) r)
          == ((->) r)         {- by id defn -}
```

Claim `fmap (f . g) m == (fmap f . fmap  g) m`

```hs
fmap (f . g) m == fmap (f . g) ((->) r) {- by m expansion -}
               == (f . g) . ((->) r)    {- by fmap defn -}

(fmap f . fmap g) m == (fmap f . fmap g) ((->) r) {- expansion of m -}
                    == fmap f (fmap g ((->) r))   {- expansion of . -}
                    == fmap f (g . ((->) r))      {- fmap defn -}
                    == f . (g . ((->) r))         {- fmap defn -}
                    == (f . g) . ((->) r)         {- by . is associative -}
```

## 3) Implement the reader functor

```js
let compose = (f, g) => x => f(g(x))
let readerMap = (f, m) => compose(f, m)

let toString = String
let double = x => x * 2

console.log(readerMap(toString, double)(10))
```

## 4) Prove the functor laws to list

Claim: `fmap id m = id m`

For empty lists

```hs
fmap id m == fmap id [] {- by m expansion -}
          == []         {- by fmap defn -}
          == id []
          == []         {- by id defn -}
```

For non-empty lists, assume that the law hold true to the tail call of fmap.

```hs
fmap id (x:xs) == id x : fmap id xs {- by fmap defn -}
               == x : fmap id xs    {- by id defn -}
               == x : xs            {- by induction -}
               == id (x:xs)
               == x : xs            {- by id defn -}
```

Claim `fmap (f . g) m == (fmap f . fmap  g) m`

For empty lists

```hs
fmap (f . g) m == fmap (f . g) [] {- by m expansion -}
               == []              {- by fmap defn -}

(fmap f . fmap g) m == (fmap f . fmap g) [] {- by m expansion -}
                    == fmap f (fmap g [])   {- by . expansion -}
                    == fmap f []            {- by fmap defn -}
                    == []                   {- by fmap defn -}
```

For non-empty lists, assume that the law hold true to the tail call of fmap.

```hs
fmap (f . g) m == fmap (f . g) (x:xs)         {- by m expansion -}
               == (f . g) x : fmap (f . g) xs {- by fmap defn -}

(fmap f . fmap g) m == (fmap f . fmap g) (x:xs)        {- by m expansion -}
                    == fmap f (fmap g (x:xs))          {- by . expansion -}
                    == fmap f (g x : fmap g xs)        {- by fmap defn -}
                    == f (g x) : fmap f (fmap g x)     {- by fmap defn -}
                    == (f . g) x : fmap f (fmap g x)   {- by composition -}
                    == (f . g) x : (fmap f . fmap g) x {- by composition -}
                    == (f . g) x : fmap (f . g) x      {- by induction -}
```
