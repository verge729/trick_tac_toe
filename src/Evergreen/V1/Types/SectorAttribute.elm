module Evergreen.V1.Types.SectorAttribute exposing (..)

import Evergreen.V1.Types.Player
import Evergreen.V1.Types.Tricks.Trick


type State
    = Free
    | Orphaned
    | Claimed Evergreen.V1.Types.Player.Player


type Content
    = Clear
    | Trick Evergreen.V1.Types.Tricks.Trick.Trick
