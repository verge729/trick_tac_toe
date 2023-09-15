module Evergreen.V2.Types.Events exposing (..)

import Evergreen.V2.Types.Coordinates
import Evergreen.V2.Types.Player
import Evergreen.V2.Types.Tricks.Trick


type EventType
    = Turn
    | Trick Evergreen.V2.Types.Tricks.Trick.Trick
    | ClaimedSector


type alias Event =
    { turn : Int
    , event : EventType
    , player : Evergreen.V2.Types.Player.Player
    , coordinates : Evergreen.V2.Types.Coordinates.CoordinateSystem
    }
