module Types.Board exposing (..)

import Array
import Types.Sector as Sector
import Types.Coordinates as Coordinates
import Url.Parser exposing (top)

type alias RegularBoard =
    Array.Array Sector.Sector

type Board
    = NotSelected
    | Regular RegularBoard

type alias BoardRows a =
    { top : a
    , middle : a
    , bottom : a
    }

boardRegular : Array.Array Sector.Sector
boardRegular =
    Array.initialize 9 (\i -> Sector.defaultSector <| Coordinates.toSectorFromInt i) 