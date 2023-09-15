module Evergreen.V1.Types.Storage.User exposing (..)

import Evergreen.V1.Types.Storage.Connectivity


type alias User =
    { handle : String
    , keyphrase : String
    , id : String
    , state : Evergreen.V1.Types.Storage.Connectivity.Connectivity
    }
