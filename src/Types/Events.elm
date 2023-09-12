module Types.Events exposing (..)

import Types.Coordinates as Coordinates
import Types.Player as Player
import Types.Tricks.Trick as Trick


type EventType
    = Turn
    | Trick Trick.Trick


type alias Event =
    { turn : Int
    , event : EventType
    , player : Player.Player
    , coordinates : Coordinates.Coordinates
    }


toStringEvent : Event -> String
toStringEvent event =
    "Turn " ++ String.fromInt event.turn ++ ": " ++ event.player.username ++ " has " ++ toStringEventType event.event

toStringEventType : EventType -> String
toStringEventType eventType =
    case eventType of
        Turn ->
            "completed their turn."

        Trick trick ->
            "triggered the " ++ Trick.toString trick ++ " trick!"