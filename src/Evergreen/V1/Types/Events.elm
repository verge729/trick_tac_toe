module Evergreen.V1.Types.Events exposing (..)

import Evergreen.V1.Types.Coordinates
import Evergreen.V1.Types.Player
import Evergreen.V1.Types.Tricks.Trick


type EventType
    = Turn
    | Trick Evergreen.V1.Types.Tricks.Trick.Trick
    | ClaimedSector


type alias Event =
    { turn : Int
    , event : EventType
    , player : Evergreen.V1.Types.Player.Player
    , coordinates : Evergreen.V1.Types.Coordinates.CoordinateSystem
    }
