module Evergreen.V2.Types.Base.Sector exposing (..)

import Evergreen.V2.Types.Coordinates
import Evergreen.V2.Types.SectorAttribute


type alias Sector =
    { state : Evergreen.V2.Types.SectorAttribute.State
    , content : Evergreen.V2.Types.SectorAttribute.Content
    , coordinate : Evergreen.V2.Types.Coordinates.Sector
    }
