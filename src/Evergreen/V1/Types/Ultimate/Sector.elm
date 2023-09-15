module Evergreen.V1.Types.Ultimate.Sector exposing (..)

import Evergreen.V1.Types.Base.Board
import Evergreen.V1.Types.Coordinates
import Evergreen.V1.Types.SectorAttribute


type alias Sector =
    { coordinate : Evergreen.V1.Types.Coordinates.Sector
    , state : Evergreen.V1.Types.SectorAttribute.State
    , board : Evergreen.V1.Types.Base.Board.RegularBoard
    }
