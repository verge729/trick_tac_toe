module Types.Player exposing (..)

import Types.Storage.User as User


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


createPlayerOne : User.User -> Player
createPlayerOne user =
    { handle = user.handle
    , icon = "X"
    }

createPlayerTwo : User.User -> Player   
createPlayerTwo user =
    { handle = user.handle
    , icon = "O"
    }

getUserFromPlayer : User.User -> User.User -> Player -> User.User
getUserFromPlayer user_one user_two player =
    if user_one.handle == player.handle then
        user_one
    else
        user_two