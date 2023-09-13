module Types.Storage.Connectivity exposing (..)

import Lamdera exposing (ClientId)

type Connectivity
    = Connected ClientId
    | Disconnected