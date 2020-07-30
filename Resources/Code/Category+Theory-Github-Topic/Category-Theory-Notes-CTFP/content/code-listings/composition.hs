f :: A -> B
g :: B -> C

composed :: A -> C
composed = g . f
