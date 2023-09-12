module Types.Ultimate.Board exposing (..)

import Array 
import Types.Ultimate.Sector as UltimateSector
import Types.Coordinates as Coordinates

type alias UltimateBoard =
    Array.Array UltimateSector.Sector

boardUltimate : (UltimateBoard, Int)
boardUltimate =
    let
        board_size =
            9
    in
    ( Array.initialize board_size (\i -> UltimateSector.defaultSector <| Coordinates.toSectorFromInt i)
    , board_size * board_size
    )
