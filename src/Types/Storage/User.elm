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


testingAgain : User
testingAgain =
    { handle = "verge2"
    , id = "1991082595"
    , keyphrase = "journey"
    , state = Connectivity.Connected "R1p5ekMiSsztXvs+KW3gLA==" 
    }

testingAgainDC : User
testingAgainDC =
    { handle = "verge2"
    , id = "1991082595"
    , keyphrase = "journey"
    , state = Connectivity.Disconnected
    }