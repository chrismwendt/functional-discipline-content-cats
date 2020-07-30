type Writer a = (a, String)
return :: a -> Writer a
return x = (x, "")
(>=>) :: (a -> Writer b) -> (b -> Writer c) -> (a -> Writer c)
