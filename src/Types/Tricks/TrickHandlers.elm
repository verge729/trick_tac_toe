module Types.Tricks.TrickHandlers exposing (..)

import Types.Tricks.Trick as Trick
import Types.Board as Board
import Types.Player as Player

type alias TrickHandler a =
    { trick_type : Trick.TrickType
    , player : Player.Player
    , turn : Int
    , board : a        
    }

handleTrickRegular : TrickHandler Board.RegularBoard -> Board.RegularBoard -> Board.RegularBoard
handleTrickRegular handler_info board =
    case handler_info.trick_type of
        Trick.Vanish ->
            board