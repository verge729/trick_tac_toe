module Evergreen.V1.Types.Victory exposing (..)

import Evergreen.V1.Types.Player


type PathToVictory
    = Acheived Evergreen.V1.Types.Player.Player
    | Unacheived
