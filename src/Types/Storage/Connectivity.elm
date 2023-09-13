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