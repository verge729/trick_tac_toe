module Types.Player exposing (..)

type alias Player =
    { username : String
    , icon : String        
    }

defaultOne : Player
defaultOne =
    { username = "Player 1"
    , icon = "X"
    }

defaultTwo : Player
defaultTwo =
    { username = "Player 2"
    , icon = "O"
    }
