module Types.Ultimate.Sector exposing (..)

import Types.Coordinates as Coordinates
import Types.Base.Board as BaseBoard
import Types.SectorAttribute as SectorAttribute

type alias Sector =
    { coordinate : Coordinates.Sector
    , state : SectorAttribute.State
    , board : BaseBoard.RegularBoard
    }

defaultSector : Coordinates.Sector -> Sector
defaultSector coordinate =
    { coordinate = coordinate
    , state = SectorAttribute.Free
    , board = Tuple.first BaseBoard.boardRegular
    }