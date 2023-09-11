module Frontend.Model exposing (..)

import Browser.Navigation exposing (Key)
import Parts.Coordinates as Coordinates

type alias FrontendModel =
    { key : Key
    , message : String 
    , current_coordinate : Maybe Coordinates.Coordinate
    , next_coordinate : Maybe Coordinates.Coordinate
    }