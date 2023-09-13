module Types.Storage.User exposing (..)
import Types.Storage.Connectivity as Connectivity

type alias User =
    { handle : String
    , keyphrase : String
    , id : String
    , state : Connectivity.Connected
    }

generateUserId : String
generateUserId =
    ""