module Evergreen.V1.Types.Base.Sector exposing (..)

import Evergreen.V1.Types.Coordinates
import Evergreen.V1.Types.SectorAttribute


type alias Sector =
    { state : Evergreen.V1.Types.SectorAttribute.State
    , content : Evergreen.V1.Types.SectorAttribute.Content
    , coordinate : Evergreen.V1.Types.Coordinates.Sector
    }
