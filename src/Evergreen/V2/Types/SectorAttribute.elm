module Evergreen.V2.Types.SectorAttribute exposing (..)

import Evergreen.V2.Types.Player
import Evergreen.V2.Types.Tricks.Trick


type State
    = Free
    | Orphaned
    | Claimed Evergreen.V2.Types.Player.Player


type Content
    = Clear
    | Trick Evergreen.V2.Types.Tricks.Trick.Trick
