import Test.QuickCheck
import HyloQuick
import Data.List

main :: IO ()
main = do
    quickCheck sortIntsProp
    quickCheck sortStringsProp

sortIntsProp :: [Int] -> Bool
sortIntsProp xs = qSort xs == sort xs

sortStringsProp :: [String] -> Bool
sortStringsProp xs = qSort xs == sort xs
