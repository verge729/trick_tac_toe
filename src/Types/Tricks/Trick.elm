module Types.Tricks.Trick exposing (..)

type TrickType
    = Vanish

type alias Trick =
    { trick_type : TrickType
    , description : String      
    }

toString : Trick -> String
toString trick =
    case trick.trick_type of
        Vanish ->
            "Vanish"

vanish : Trick
vanish =
    { trick_type = Vanish
    , description = "Vanish"
    }