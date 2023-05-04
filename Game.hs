import Board

play :: Board -> IO ()
play board | winner board == 1 = putStrLn "X wins!"
           | winner board == 2 = putStrLn "O wins!"
           | isDraw board == True = putStrLn "Ta3adol"
           | otherwise = do
                c <- readInteger (playerTurn board)
                ok <- checkMove board c
                let board1 = if ok  then makeMove board c (playerTurn board) else board
                putStrLn ("\n" ++ (showBoard board1))
                play board1

checkMove :: Board -> Column -> IO Bool
checkMove b c = do
                let x = isLegalMove b c
                putStr (if not x then "mamno3!\n" else "")
                return (x)

readInteger :: Player -> IO Int
readInteger player = do
                     putStr "\ndoor "
                     putStr (show player)
                     putStrLn ": "
                     x<-getLine
                     return (read x)

main :: IO ()
main = do 
        let board = newBoard (3, 3)
        putStrLn ("\n" ++ (showBoard board))
        play (board)
