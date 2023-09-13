module Types.Events exposing 
    ( EventType(..)
    , Event
    , toStringEvent        
    )

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
    , coordinates : Coordinates.CoordinateSystem
    }

toStringEvent : Event -> String
toStringEvent event =
    toString event.turn event.player event.event


toString : Int -> Player.Player -> EventType -> String
toString turn player eventType =
    "Turn " ++ String.fromInt turn ++ ": " ++ player.username ++ " has " ++ toStringEventType eventType

toStringEventType : EventType -> String
toStringEventType eventType =
    case eventType of
        Turn ->
            "completed their turn."

        Trick trick ->
            "triggered the " ++ Trick.toString trick ++ " trick!"