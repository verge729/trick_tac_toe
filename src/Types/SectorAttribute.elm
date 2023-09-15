module Types.SectorAttribute exposing (..)

import Types.Player as Player
import Types.Tricks.Trick as Trick
import Types.Storage.User as User


type Treat
    = Treat

type Content
    = Clear
    | Trick Trick.Trick

type State 
    = Free
    | Orphaned
    | Claimed Player.Player

toStringState : State -> String
toStringState state =
    case state of
        Free ->
            "Free"

        Orphaned ->
            "Orphaned"

        Claimed player ->
            "Claimed by " ++ player.handle
