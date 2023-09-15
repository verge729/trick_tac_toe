module Evergreen.V2.Types.Victory exposing (..)

import Evergreen.V2.Types.Player


type PathToVictory
    = Acheived Evergreen.V2.Types.Player.Player
    | Unacheived
