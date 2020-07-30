type Events = [String]
type Probs = [Double]

data PTable = PTable Events Probs

createPTable :: Events -> Probs -> PTable
createPTable events probs = PTable events normalizedProbs
  where totalProbs = sum probs
        normalizedProbs = map (\x -> x/totalProbs) probs

showResult :: String -> Double -> String
showResult event prob = mconcat [event, "|", show prob, "\n"]

instance Show PTable where
  show (PTable events probs) = mconcat results
    where results = zipWith showResult events probs

cartCombine :: (a -> b -> c) -> [a] -> [b] -> [c]
cartCombine func l1 l2 = zipWith func newL1 cycledL2
  where nToAdd = length l2
        repeatedL1 = map (take nToAdd . repeat) l1
        newL1 = mconcat repeatedL1
        cycledL2 = cycle l2

combineEvents :: Events -> Events -> Events
combineEvents e1 e2 = cartCombine combiner e1 e2
  where combiner = (\x y -> mconcat[x, "-", y])

combineProbs :: Probs -> Probs -> Probs
combineProbs p1 p2 = cartCombine (*) p1 p2

instance Semigroup PTable where
  (<>) ptable1 (PTable [][]) = ptable1
  (<>) (PTable [][]) ptable2 = ptable2
  (<>) (PTable e1 p1)(PTable e2 p2) =
    createPTable newEvents newProbs
      where newEvents = combineEvents e1 e2
            newProbs = combineProbs p1 p2

instance Monoid PTable where
  mempty = PTable [][]
  mappend = (<>)

cards :: PTable
cards = createPTable ["6", "7"] [1/13, 1/13]

suits :: PTable
suits = createPTable ["♠", "♥", "♦", "♣"][0.25, 0.25, 0.25, 0.25]

main = do print (cards <> suits)
