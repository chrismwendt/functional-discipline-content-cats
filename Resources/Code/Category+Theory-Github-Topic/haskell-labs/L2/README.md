# Lecture 2 28.02.19

Lambda calculus

Backus-Naur form for lambda calc grammar:
``` haskell 
data LTerm = Var Int | Lambda Int LTerm | Appl LTerm LTerm
-- E = x | lambda x.E | EE
```

