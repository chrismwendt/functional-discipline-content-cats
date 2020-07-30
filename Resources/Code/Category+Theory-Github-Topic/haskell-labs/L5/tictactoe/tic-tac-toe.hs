import Control.Monad
import Board 
import Helpers

-- Check if game is over or not
checkGameStatus :: Board -> Mark -> IO()
checkGameStatus b m
    | inLine m b = putStrLn $ "Game over! Player " ++ (show m) ++ " won!"
    | isFull b = putStrLn "Game over! Draw."
    | otherwise = game b nm
    where
        nm = if (m==X) then O else X
    

-- Loop for the tic-tac-toe game
game :: Board -> Mark -> IO()
game b m = do
    -- Player move
    putStrLn $ "Move of player " ++ show m
    b1 <- getLine >>= return . (\p -> addMark p m b)
    print b1
    checkGameStatus b1 m


main :: IO()
main = do
    putStrLn "<<<< COSMIC TIC-TAC-TOE >>>>"
    putStrLn "Who starts? [X / O]"
    m <- getLine >>= return . (\x -> read x :: Mark)
    
    -- Show board coords
    putStrLn "\nTo make a move input something like 'a2'."
    putStrLn "  | 1 | 2 | 3"
    putStrLn $ unlines $ map (\(a, b) -> (a ++ b)) (zip ["a | " , "b | ", "c | "] (lines $ show Empty))

    -- Start the game
    game Empty m
    