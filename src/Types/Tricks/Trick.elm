module Types.Tricks.Trick exposing (..)

type TrickType
    = Vanish

type alias Trick =
    { trickType : TrickType
    , description : String      
    }

toString : Trick -> String
toString trick =
    case trick.trickType of
        Vanish ->
            "Vanish"

vanish : Trick
vanish =
    { trickType = Vanish
    , description = "Vanish"
    }