module Types.Ultimate.Sector exposing (..)

import Types.Coordinates as Coordinates
import Types.Base.Board as BaseBoard
import Types.Victory as Victory

type alias Sector =
    { coordinate : Coordinates.Sector
    , state : Victory.PathToVictory
    , board : BaseBoard.RegularBoard
    }

defaultSector : Coordinates.Sector -> Sector
defaultSector coordinate =
    { coordinate = coordinate
    , state = Victory.Unacheived
    , board = BaseBoard.boardRegular
    }