import Data.List
import qualified Data.Map.Strict as M
import Control.Monad
import Control.Monad.Trans.Class
import Control.Monad.Trans.State.Strict
import System.Environment
import System.IO.Error
import Text.Read hiding (get, lift)


data Priority = 
    High | Medium | Low 
    deriving (Eq, Show, Read)


instance Ord Priority where
    compare High Medium = GT
    compare High Low = GT
    compare Medium Low = GT
    compare Medium High = LT
    compare Low High = LT
    compare Low Medium = LT

type Task = String

type StIO a = StateT [(Task, Priority)] IO a


sortPrior :: [(Task, Priority)] -> [(Task, Priority)]
sortPrior tasks =
    sortBy (\(_, a) (_, b) -> compare b a) tasks


addTask :: Task -> Priority -> StIO ()
addTask task prio =
    modify (\ts -> sortPrior $ ts ++ [(task, prio)])


getTask :: StIO (Maybe (Task, Priority))
getTask = do
    ts <- get
    case length ts of
        0 -> return $ Nothing
        _ -> return $ Just $ head ts

        
markDone :: StIO ()
markDone = 
    modify tail


priorityInput :: StIO Priority
priorityInput = do
    lift $ putStrLn "Priority (High, Medium, Low)"
    priority <- lift $ getLine >>= \x -> return ( read x :: Priority)
    return priority


addPrompt :: StIO ()
addPrompt = do
    lift $ putStrLn "Task description: "
    task <- lift $ getLine
    lift $ putStrLn "Priority"
    priority <- priorityInput
    addTask task priority


cmdLoop :: StIO ()
cmdLoop = do
    cmd <- lift $ getLine
    case cmd of
        "done" -> markDone >> mainLoop
        "add" -> addPrompt >> mainLoop
        _ -> mainLoop


mainLoop :: StIO ()
mainLoop = do
    top <- getTask
    case top of
        Nothing -> do
            lift $ putStrLn "All done! Add new task:"
            cmdLoop

        Just task -> do
            lift $ putStrLn "Actual task: "
            lift $ print task
            lift $ putStrLn "Action: done / add new: "
            cmdLoop


main :: IO [(Task, Priority)]
main =
    execStateT mainLoop []
    