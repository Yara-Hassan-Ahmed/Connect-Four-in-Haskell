module Board(
  Row,
  Column,
  Player(..),
  Board,
  newBoard,
  isDraw,
  showBoard,
  isLegalMove,
  makeMove,
  winner,
  playerTurn,
  )
------------------------------------------------------------------------------------
where
import Data.List

type Column = Int
type Row    = Int

data Player = X | O | None deriving (Eq, Show)

data Board  = Con [[Player]] (Row, Column) deriving (Eq)

newBoard:: (Row, Column) -> Board
newBoard (r, c) = Con (replicate c []) (r, c)

------------------------------------------------------------------------------------

checkColumn :: [Player] -> Player -> Bool
checkColumn [] player = False
checkColumn (x:y:z:ls) player | x==y && x==z && x == player = True
                                | otherwise = checkColumn (y:z:ls) player
checkColumn (x:xs) player = False

checkVertical :: Board -> Player -> Bool
checkVertical (Con [] (r, c)) player = False
checkVertical (Con (x:xs) (r, c)) player = (checkColumn x player) || (checkVertical  (Con xs (r, c)) player)

playerSwaping :: Player -> Player
playerSwaping player = if player == X then O else X

------------------------------------------------------------------------------------

getItem :: Board -> Int -> Int ->  Player ->  Player
getItem  (Con xs (r, c)) a b player | b < length col = col !! b
                                    | otherwise = player
                        where
                            col | a < length xs = xs!!a
                                | otherwise = []

rightCheckDiagonalsItem :: Board -> Player -> Int -> Int -> Bool
rightCheckDiagonalsItem board player a b = c1 ==  c2 && c1 == c3 && c1 == player
            where
                player' = playerSwaping player
                c1 = getItem board a b player'
                c2 = getItem board (a+1) (b+1) player'
                c3 = getItem board (a+2) (b+2) player'
                
                
rightCheckDiagonalsIter :: Board -> Player -> Int -> Int -> Bool
rightCheckDiagonalsIter board@(Con xss (r, c)) player a b | a>c-3 && b > r - 4 = False
                                                          | a>c-3 = rightCheckDiagonalsIter board player 0 (b+1)
                                                          | otherwise = rightCheckDiagonalsItem board player a b || rightCheckDiagonalsIter board player (a+1) b

rightCheckDiagonals :: Board -> Player -> Bool
rightCheckDiagonals  board player = rightCheckDiagonalsIter  board player 0 0

------------------------------------------------------------------------------------

leftCheckDiagonalsItem :: Board -> Player -> Int -> Int -> Bool
leftCheckDiagonalsItem board player a b = c1 ==  c2 && c1 == c3 && c1 == c4 && c1 == player
            where
                player' = playerSwaping player
                c1 = getItem board a b player'
                c2 = getItem board (a-1) (b+1) player'
                c3 = getItem board (a-2) (b+2) player'
                c4 = getItem board (a-3) (b+3) player'

leftCheckDiagonalsIter :: Board -> Player -> Int -> Int -> Bool
leftCheckDiagonalsIter board@(Con xss (r,c)) player a b | a >= c && b < (r-3) = leftCheckDiagonalsIter board player 3 (b+1)
                                                        | a >= c && b >= (r-3) = False
                                                        | otherwise = leftCheckDiagonalsItem board player a b || leftCheckDiagonalsIter board player (a+1) b

leftCheckDiagonals :: Board -> Player -> Bool
leftCheckDiagonals  board@(Con xss (r, c))  player | c > 3 = leftCheckDiagonalsIter board player 3 0
                                                   | otherwise = False

------------------------------------------------------------------------------------
fillRow :: Board -> Int -> Board
fillRow board@(Con xss (r, c)) n = if not (n == (-1))
                    then fillRow (makeMove board n None) (n-1)
                    else board
                
fill :: Board -> Int -> Board
fill board@(Con xss (r, c)) 0 =  board
fill board@(Con xss (r, c)) n = fill (fillRow board 3) (n-1)

transboard :: Board -> Board
transboard board@(Con xss (r,c)) = ps2b ( transpose ( b2ps (fill board 3))) r c

b2ps :: Board -> [[Player]]
b2ps (Con xss (r, c)) = xss

ps2b :: [[Player]] -> Row -> Column -> Board
ps2b xss r c = (Con xss (r,c))

------------------------------------------------------------------------------------

check :: Board -> Player -> Bool
check board player = (leftCheckDiagonals board player) || (rightCheckDiagonals board player) || (checkVertical board player) || (checkVertical (transboard board) player)

winner :: Board -> Int
winner board | check board X = 1
             | check board O = 2
             | otherwise = 0
------------------------------------------------------------------------------------

isDraw:: Board -> Bool
isDraw (Con [] z) = True
isDraw (Con (x:xs) (r, c)) = length x == r && isDraw (Con xs (r, c)) 

------------------------------------------------------------------------------------

showBoard:: Board -> String
showBoard board@(Con xss (r,c)) = (displayBoard board 1) ++ trailer (c-1)

trailer :: Int -> String
trailer n | n == -1 = "+\n"
          | otherwise = "+-" ++ trailer (n-1) ++ " " ++ (show n)

displayCell :: [Player] -> Int -> String
displayCell [] player = " |"
displayCell board 1 | head board ==X = "O|"
                    | otherwise = "K|"
displayCell board player | player > (length board) = " |"
                         | otherwise = (displayCell (tail board) (player-1))

displayRow :: [[Player]] -> Int -> String
displayRow [x] player = displayCell x player
displayRow (x:xs) player = displayCell x player ++ displayRow xs player

displayBoard :: Board -> Int -> String
displayBoard (Con xss (r, c)) n | n >= (c-1) = "|" ++ displayRow xss n ++ "\n"
                                | otherwise = displayBoard (Con xss (r, c)) (n+1) ++ "|"  ++ displayRow xss n ++ "\n"

------------------------------------------------------------------------------------

isLegalMove:: Board -> Column -> Bool
isLegalMove (Con [] (r, c)) col = True
isLegalMove (Con xss (r, c)) col | col >= c = False
                                 | otherwise = (kk < r)
                        where
                            kk = length k
                            k  = (xss !! col)

------------------------------------------------------------------------------------

makeMove :: Board -> Column -> Player -> Board
makeMove board@(Con xss (r, c)) column player = Con (a ++ b ++ c') (r, c)
          where a  = (firstHalf xss column)
                b  = [((xss !! column) ++ [player])]
                c' = (secondHalf xss column)

firstHalf:: [[Player]] -> Int -> [[Player]]
firstHalf xss n = take n xss

secondHalf:: [[Player]] -> Int -> [[Player]]
secondHalf xss n = drop (n + 1) xss

------------------------------------------------------------------------------------

playerTurn :: Board -> Player
playerTurn (Con board (r, c)) = if rc > yc then O else X
            where
                rc = length (filter (==X) longBoard)
                yc = length (filter (==O) longBoard)
                longBoard = concat board
                
