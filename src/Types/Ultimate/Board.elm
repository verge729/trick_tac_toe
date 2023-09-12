module Types.Ultimate.Board exposing (..)

import Array 
import Types.Ultimate.Sector as UltimateSector
import Types.Coordinates as Coordinates

type alias UltimateBoard =
    Array.Array UltimateSector.Sector

boardUltimate : UltimateBoard
boardUltimate =
    Array.initialize 9 (\i -> UltimateSector.defaultSector <| Coordinates.toSectorFromInt i)
