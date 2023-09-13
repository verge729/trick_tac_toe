module Types.Player exposing (..)

type alias Player =
    { handle : String
    , icon : String        
    }

defaultOne : Player
defaultOne =
    { handle = "Player 1"
    , icon = "X"
    }

defaultTwo : Player
defaultTwo =
    { handle = "Player 2"
    , icon = "O"
    }
