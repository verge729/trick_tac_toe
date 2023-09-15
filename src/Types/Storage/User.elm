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
    { handle = "hoid"
    , id = "1991082495"
    , keyphrase = "journey"
    , state = Connectivity.Connected "R1p5ekMiSsztXvs+KW3gLA=="
    }


testingAgain : User
testingAgain =
    { handle = "shallan"
    , id = "1991082595"
    , keyphrase = "journey"
    , state = Connectivity.Connected "R1p5ekMiSsztXvs+KW3gLA=="
    }


testingAgainDC : User
testingAgainDC =
    { handle = "vin"
    , id = "1991082595"
    , keyphrase = "journey"
    , state = Connectivity.Disconnected
    }
