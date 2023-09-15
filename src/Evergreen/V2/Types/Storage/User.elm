module Evergreen.V2.Types.Storage.User exposing (..)

import Evergreen.V2.Types.Storage.Connectivity


type alias User =
    { handle : String
    , keyphrase : String
    , id : String
    , state : Evergreen.V2.Types.Storage.Connectivity.Connectivity
    }
