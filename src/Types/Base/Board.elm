module Types.Base.Board exposing (..)

import Array
import Types.Base.Sector as Sector
import Types.Coordinates as Coordinates
import Types.SectorAttribute as SectorAttribute
import Types.Tricks.Trick as Trick


type alias RegularBoard =
    Array.Array Sector.Sector


boardRegular : RegularBoard
boardRegular =
    Array.initialize 9 (\i -> Sector.defaultSector <| Coordinates.toSectorFromInt i)

addTricks : RegularBoard -> RegularBoard
addTricks board  =
    let
        m_sector =
            Array.get 0 board
    in
    case m_sector of
        Just sector ->
            Array.set 0 { sector | content = SectorAttribute.Trick Trick.vanish } board

        Nothing ->
            board