module Types.Events exposing 
    ( EventType(..)
    , Event
    , toStringEventUltimate
    , toStringEventRegular        
    )

import Types.Coordinates as Coordinates
import Types.Player as Player
import Types.Tricks.Trick as Trick


type EventType
    = Turn
    | Trick Trick.Trick


type alias Event a =
    { turn : Int
    , event : EventType
    , player : Player.Player
    , coordinates : a
    }

toStringEventUltimate : Event Coordinates.Coordinates -> String
toStringEventUltimate event =
    toString event.turn event.player event.event

toStringEventRegular : Event Coordinates.Sector -> String
toStringEventRegular event =
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