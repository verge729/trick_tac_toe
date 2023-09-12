module Types.Ultimate.Board exposing (..)

import Array 
import Types.Ultimate.Sector as UltimateSector
import Types.Coordinates as Coordinates
import Random
import Types.Base.Board as BaseBoard

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

checkSectors : Coordinates.Coordinates -> List Coordinates.Sector -> Bool
checkSectors coordinates sectors =
    List.member coordinates.low sectors && List.member coordinates.mid sectors

addTricks : UltimateBoard -> Random.Seed -> (UltimateBoard, Random.Seed)
addTricks board_mid seed =
    let
        (sectors, new_seed) =
            Random.step Coordinates.randomGeneratorUltimate seed
    in 
    Array.foldl (\sector (array, next_new_seed) ->
        if List.member sector.coordinate sectors then
            let
                (tricked_board, n_seed) =
                    BaseBoard.addTricks sector.board next_new_seed
            in
            (Array.push { sector | board = tricked_board} array, n_seed)
        else
            (Array.push sector array, next_new_seed)
    ) (Array.empty, new_seed) board_mid