module Types.Storage.Connectivity exposing (..)

import Lamdera exposing (ClientId)

type Connectivity
    = Connected ClientId
    | Disconnected

getClientId : Connectivity -> ClientId
getClientId connectivity =
    case connectivity of
        Connected clientId ->
            clientId

        Disconnected ->
            ""

sort : Connectivity -> Connectivity -> Connectivity
sort first second =
    case (first, second) of
        (Connected _, Disconnected) ->
            first

        (Disconnected, Connected _) ->
            second

        (Connected firstId, Connected secondId) ->
            if firstId < secondId then
                first
            else
                second

        (Disconnected, Disconnected) ->
            first