module Types.Tricks.TrickHandlers exposing (..)

import Types.Tricks.Trick as Trick
import Types.Board as Board
import Types.Player as Player
import Types.Coordinates as Coordinates
import Types.Base.Board as BaseBoard
import Types.SectorAttribute as SectorAttribute

type alias TrickHandler a =
    { trick_type : Trick.TrickType
    , player : Player.Player
    , turn : Int
    , coordinates : Coordinates.Sector
    , board : a        
    }

handleTrickRegular : TrickHandler Board.RegularBoard -> Board.RegularBoard
handleTrickRegular handler_info =
    case handler_info.trick_type of
        Trick.Vanish ->
            BaseBoard.updateBoard handler_info.board handler_info.coordinates SectorAttribute.Free