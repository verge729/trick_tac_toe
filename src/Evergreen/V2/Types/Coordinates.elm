module Evergreen.V2.Types.Coordinates exposing (..)


type Sector
    = Zero
    | One
    | Two
    | Three
    | Four
    | Five
    | Six
    | Seven
    | Eight


type alias Coordinates =
    { low : Sector
    , mid : Sector
    }


type CoordinateSystem
    = Regular Sector
    | Ultimate Coordinates
