module Types.SectorAttribute exposing (..)

import Types.Player as Player

type Trick
    = Trick 

type Blessing
    = Blessing

type Content
    = Clear

type State 
    = Free
    | Blocked
    | Claimed Player.Player

toStringState : State -> String
toStringState state =
    case state of
        Free ->
            "Free"

        Blocked ->
            "Blocked"

        Claimed player ->
            "Claimed by " ++ player.username