module Evergreen.V2.Types.Tricks.Trick exposing (..)


type TrickType
    = Vanish
    | WrongDestination


type alias Trick =
    { trick_type : TrickType
    , description : String
    , triggered : Bool
    }
