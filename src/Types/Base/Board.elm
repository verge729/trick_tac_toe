module Types.Base.Board exposing (..)

import Array
import Types.Base.Sector as Sector
import Types.Coordinates as Coordinates


type alias RegularBoard =
    Array.Array Sector.Sector


boardRegular : RegularBoard
boardRegular =
    Array.initialize 9 (\i -> Sector.defaultSector <| Coordinates.toSectorFromInt i)
