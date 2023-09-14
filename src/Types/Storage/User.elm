module Types.Storage.User exposing (..)
import Types.Storage.Connectivity as Connectivity

type alias User =
    { handle : String
    , keyphrase : String
    , id : String
    , state : Connectivity.Connectivity
    }

testing : User
testing =
    { handle = "verge"
    , id = "1991082495"
    , keyphrase = "journey"
    , state = Connectivity.Connected "R1p5ekMiSsztXvs+KW3gLA==" 
    }