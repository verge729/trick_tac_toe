module Types.Base.Board exposing (..)

import Array
import Types.Base.Sector as Sector
import Types.Coordinates as Coordinates
import Types.SectorAttribute as SectorAttribute
import Types.Tricks.Trick as Trick
import Types.Player as Player


type alias RegularBoard =
    Array.Array Sector.Sector


boardRegular : RegularBoard
boardRegular =
    Array.initialize 9 (\i -> Sector.defaultSector <| Coordinates.toSectorFromInt i)

updateBoard : RegularBoard -> Coordinates.Sector -> SectorAttribute.State -> RegularBoard
updateBoard board coordinate state =
    let
        int_sector =
            Coordinates.toIntSector coordinate

        m_target_sector =
            Array.get int_sector board
    in 
    case m_target_sector of
        Just target_sector ->
            Array.set 
                int_sector 
                { target_sector | state = state } 
                board

        Nothing ->
            board

addTricks : RegularBoard -> RegularBoard
addTricks board  =
    Array.map (\sector ->
        if sector.coordinate == Coordinates.Two then
            { sector | content = SectorAttribute.Trick Trick.vanish }
        else if sector.coordinate == Coordinates.Three then
            { sector | content = SectorAttribute.Trick Trick.wrongDestination }
        else
            sector
    ) board