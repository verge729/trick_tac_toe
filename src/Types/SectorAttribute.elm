module Types.SectorAttribute exposing (..)

import Types.Player as Player
import Types.Tricks.Trick as Trick


type Treat
    = Treat

type Content
    = Clear
    | Trick Trick.Trick

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
            "Claimed by " ++ player.handle
