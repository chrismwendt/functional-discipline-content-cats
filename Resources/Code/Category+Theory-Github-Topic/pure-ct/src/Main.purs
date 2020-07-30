module Main where

import Prelude
import Control.Monad.Aff (Aff, makeAff, launchAff, runAff)
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Class (liftEff)
import Control.Monad.Eff.Console (CONSOLE, log)
import Control.Monad.Eff.Exception (Error, EXCEPTION)
import Data.Argonaut.Core (Json)
import Data.Argonaut.Parser (jsonParser)
import Data.Either (Either)
import Data.Maybe (Maybe(Just), isJust, fromMaybe)
import Data.String (toUpper, trim)
import Data.List (List)
import Data.Array (head, filter)

type User = { name :: String
            , age :: Int
            }

showUser :: User -> String
showUser user = show user.name <> " " <> show user.age

userData :: Array User
userData = [{name: "Tom", age: 25}, {name: "John", age: 30}]

userDataString :: String
userDataString = "[{\"name\": \"Tom\", \"age\": 25}, {\"name\": \"John\", \"age\": 30}]"

parseUsers :: String -> Either String Json
parseUsers users = jsonParser users

-- Simple usage of Either
-- main :: forall e. Eff (console :: CONSOLE | e) Unit
-- main = do
--   log $ show $ parseUsers userDataString

-----------------------------------------------------------------------------------------

safeHead :: forall a. Array a -> Maybe a
safeHead array = head array

-- main :: forall e. Eff (console :: CONSOLE | e) Unit
-- main = do
--   log $ showMaybe $ safeHead ["a", "b", "c"]
--   log $ showMaybe $ safeHead []
--   where
--     showMaybe x = fromMaybe "Nothing" x

userInput :: Maybe String
userInput = pure "Tom"
-- userInput = Just "Tom"

getUserByName :: String -> Maybe User
getUserByName name = (head <<< filter fn) userData
  where fn user = user.name == name

main :: forall e. Eff (console :: CONSOLE | e) Unit
main = do
  log $ show $ map showUser $ userInput >>= getUserByName
  log $ show $ map showUser $ join $ map getUserByName userInput
  log $ show $ map showUser $ join $ getUserByName <$> userInput


-----------------------------------------------------------------------------------------


-- functor should preserve composition morphisms
-- main :: forall e. Eff (console :: CONSOLE | e) Unit
-- main = do
--   log $ show $ map (toUpper <<< trim) $ Just(" john ")
--   log $ show $ map toUpper <<< map trim $ Just(" john ")
--   log $ show $ map toUpper $ map trim $ Just(" john ")


-----------------------------------------------------------------------------------------

foreign import get :: forall e. String -> (Error -> Eff e Unit) -> (String -> Eff e Unit) -> Eff e Unit

get' :: forall e. String -> Aff e String
get' url = makeAff (\error success -> get url error success)

-- main = launchAff do
--   result <- get' "https://api.github.com/repos/peter-vilja/unlock-elm/commits"
--   liftEff $ log result

-- main = runAff
--        (log <<< show)
--        log
--        $ get' "https://api.github.com/repos/peter-vilja/unlock-elm/commits"
