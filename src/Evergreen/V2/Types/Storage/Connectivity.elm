module Evergreen.V2.Types.Storage.Connectivity exposing (..)

import Lamdera


type Connectivity
    = Connected Lamdera.ClientId
    | Disconnected
