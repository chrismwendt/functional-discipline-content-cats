module SpaceAge (Planet(..), ageOn) where

data Planet = Mercury
            | Venus
            | Earth
            | Mars
            | Jupiter
            | Saturn
            | Uranus
            | Neptune

ageOn :: Planet -> Float -> Float
ageOn planet seconds = seconds / orbitalPeriod planet

orbitalPeriod :: Planet -> Float
orbitalPeriod planet = 31557600 * scale where
  scale = case planet of
    Just a -> body
    _ -> remaining
