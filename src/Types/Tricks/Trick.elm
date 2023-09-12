module Types.Tricks.Trick exposing (..)

type TrickType
    = Vanish
    | WrongDestination 

type alias Trick =
    { trick_type : TrickType
    , description : String 
    , triggered : Bool     
    }

toString : Trick -> String
toString trick =
    case trick.trick_type of
        Vanish ->
            "Vanish"

        WrongDestination ->
            "Wrong Destination"

vanish : Trick
vanish =
    { trick_type = Vanish
    , description = "Vanish"
    , triggered = False
    }

wrongDestination : Trick
wrongDestination =
    { trick_type = WrongDestination
    , description = "Wrong Destination"
    , triggered = False
    }