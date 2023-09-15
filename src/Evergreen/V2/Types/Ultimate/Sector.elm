module Evergreen.V2.Types.Ultimate.Sector exposing (..)

import Evergreen.V2.Types.Base.Board
import Evergreen.V2.Types.Coordinates
import Evergreen.V2.Types.SectorAttribute


type alias Sector =
    { coordinate : Evergreen.V2.Types.Coordinates.Sector
    , state : Evergreen.V2.Types.SectorAttribute.State
    , board : Evergreen.V2.Types.Base.Board.RegularBoard
    }
