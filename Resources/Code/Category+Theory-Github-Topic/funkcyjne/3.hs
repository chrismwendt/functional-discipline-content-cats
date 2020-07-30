-- 1
(\x y -> x + y)
(\x y -> x * y)

-- 4
f x y = (\x -> (\y -> x + 2 * y)) (x*y)
--alpha conversion
f x y = (\a -> (\b -> a + 2* b)) (x*y)
--beta reduction
f x y = (\b -> x*y + 2*b)

-- 5
f = \x -> x * x
g = \y -> f (f y)
h = g . g
h a = f (f (f (f a))
h a = (a * a) * (a * a) * (a * a) * (a * a) * (a * a) * (a * a) * (a * a) * (a * a)

-- 6
(\x -> (x x)) (\x -> x) -- ???

-- 7
(head $ map (\x y -> (x * x) + (y * y) ) [2 ,3 ,4]) 5
-- wynik to 29
-- kolejno:
-- map (...) [...] zwraca listę funkcji jednoargumentowych
-- head zwraca pierwszą z tych funkcji - 2*2 + x*x
-- wywołujemy zwróconą funkcję dla 5 i dostajemy 2*2 + 5*5

-- 8
S = (\f g x -> f x (g x))
K = (\x y -> x)
I = (\x -> x)
-- teraz (nie skompiluje się)
S K K = (\f g x -> f x (g x)) (\x y -> x) (\x y -> x) =
    -- alfa konwersja
    (\f g x -> f x (g x)) (\a b -> a) (\c d -> c) =
    (\x -> (\a b -> a) x ((\c d -> c) x)) =
    (\x -> (\a b -> a) x x) =
    (\x -> x)