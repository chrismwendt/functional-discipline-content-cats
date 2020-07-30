import System.IO

-- Computation hGetContents hdl returns the list of characters corresponding 
-- to the unread portion of the channel or file managed by hdl, which is put 
-- into an intermediate state, semi-closed. In this state, hdl is effectively 
-- closed, but items are read from hdl on demand and accumulated in a special 
-- list returned by hGetContents hdl.
-- hGetContents :: Handle -> IO String

-- chain IO [String] with injected length of lines
counter :: Handle -> IO Int
counter hdl = hGetContents hdl >>= return . length . lines


main :: IO()
main = do 
    putStrLn "Provide path to file"
    getLine >>= \p -> withFile p ReadMode $ \hdl -> 
        counter hdl >>= \x -> print x
