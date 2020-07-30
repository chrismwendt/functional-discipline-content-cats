module PhoneBook (main) where
    
import Data.List
import qualified Data.Map.Strict as M
import Control.Monad
import Control.Monad.Trans.Class
import Control.Monad.Trans.State.Strict
import System.Environment
import System.IO.Error


type Phone = String
type Name = String

type StIO a = StateT (M.Map Name Phone) IO a


-- UPDATE

storePhone :: Name -> Phone -> StIO ()
storePhone n p =
    modify' (\m -> M.insert n p m) 


findByPrefix :: Name -> StIO [(Name, Phone)]
findByPrefix name =
    get >>= \xs -> 
        return $ filter (\(n, p) -> name `isPrefixOf` n ) (M.toAscList xs)


removePhone :: Phone -> StIO ()
removePhone phone =
    get >>= \xs -> put $ M.filter (\p -> p /= phone) xs


showAll :: StIO [(Name, Phone)]
showAll =
    get >>= return . M.toAscList

-- VIEW

ask :: String -> StIO String
ask prompt = 
    lift $ putStrLn prompt >> getLine


addNewPhoneCmd :: StIO ()
addNewPhoneCmd = 
    ask "Your name?" >>= \name ->
        ask "What your phone?" >>= \phone ->
            storePhone name phone


findPhoneCmd :: StIO ()
findPhoneCmd =
    ask "Search by name: " >>= 
        findByPrefix >>=
            lift . print

removePhoneCmd :: StIO ()
removePhoneCmd =
    ask "Remove phone number: " >>= 
        removePhone

showAllCmd :: StIO ()
showAllCmd =
    showAll >>= lift . print


commands :: M.Map String (StIO Bool)
commands = M.fromList [
    ("add", addNewPhoneCmd >> return True),
    ("find", findPhoneCmd >> return True),
    ("remove", removePhoneCmd >> return True),
    ("show", showAllCmd >> return True),
    ("exit", return False)
    ]


unknownCmd :: StIO Bool
unknownCmd = (lift $ putStrLn "Unknown command") >> return True


readCmd :: StIO Bool
readCmd = 
    lift getLine >>= \cmd -> M.findWithDefault unknownCmd cmd commands

-- MAIN

mainLoop :: StIO ()
mainLoop = do
    input <- readCmd
    case input of
        True -> mainLoop
        False -> return ()

main :: IO ()
main = do
    (file:_) <- getArgs
    init <- catchIOError (do
        m <- read <$!> (readFile file)
        print m >> return m ) (\err -> if isDoesNotExistError err then return M.empty else ioError err)

    finalMap <- execStateT mainLoop init 
    writeFile file $ show finalMap

