# Connect-Four-in-Haskell
This is a console-based implementation of the Connect Four game written in Haskell. The game is played by two players who take turns placing pieces on a vertical board with 6 rows and 7 columns. The first player to line up four pieces in a row, whether it be horizontal, vertical, or diagonal, wins the game.

# Usage
To play the game, simply run the Main.hs file using the runhaskell command:

        $ runhaskell Main.hs

The game will start, and each player will take turns entering the column number where they want to place their piece.

# Project Structure
The project consists of two main files: Board.hs and Main.hs.

  # Board.hs
   This file defines a module Board that provides functions for creating and manipulating a Connect Four board game. The Board data type represents the game board as a list of lists of player values (Yara, Kamal, or None). It also includes the dimensions of the board as a tuple of row and column values. The module provides functions for checking the winner, making a move, and showing the board.

  # Main.hs
   This file contains the main game loop and user interface. It prompts the players to enter their moves and updates the board after each move. The play function is the main game loop, which continues until a player wins, the game is a draw, or the game is otherwise terminated.

# Functions
The following functions are available in the Board module:

  newBoard :: (Row, Column) -> Board: creates a new board with all positions initialized to None
  isDraw :: Board -> Bool: returns True if the board is full and there is no winner, False otherwise
  showBoard :: Board -> String: returns a string representation of the board
  winner :: Board -> Player: returns the player value of the winner, if there is one, None otherwise
  isLegalMove :: Board -> Player -> Column -> Bool: returns True if the move is legal (i.e., the column is not full), False otherwise
  makeMove :: Board -> Player -> Column -> Board: returns a new board with the player value added to the specified column, if the move is legal. If the move is illegal, it returns the original board.
