module Types.Ultimate.Board exposing (..)

import Array 
import Types.Ultimate.Sector as UltimateSector
import Types.Coordinates as Coordinates
import Random
import Types.Base.Board as BaseBoard
import Types.SectorAttribute as SectorAttribute
import Types.Victory as Victory
import Types.Player as Player

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

updateBoard : UltimateBoard -> Coordinates.Coordinates -> SectorAttribute.State -> Player.Player -> UltimateBoard
updateBoard board coordinates state current_player =
    let
        int_sector =
            Coordinates.toIntSector coordinates.mid
    in
    case Array.get int_sector board of
        Just board_low ->
            let
                updated_board=
                    BaseBoard.updateBoard board_low.board coordinates.low state
                
                claimed_victory =
                    Victory.checkVictory updated_board current_player

                updated_ultimate_sector =
                    case board_low.state of
                        SectorAttribute.Free ->
                            { board_low | board = updated_board, state = Victory.toStatePathToVictory claimed_victory }

                        SectorAttribute.Claimed _ ->
                            { board_low | board = updated_board }

                        SectorAttribute.Blocked ->
                            board_low

                finalized_board =
                    Array.set int_sector updated_ultimate_sector board
                        |> checkAndUpdateForBlock
            in
            finalized_board

        Nothing ->
            board


checkAndUpdateForBlock : UltimateBoard -> UltimateBoard
checkAndUpdateForBlock board =
    let
        m_blocked_sector =
            Array.foldl (\sector m_sector_low ->
                if checkForBlockRegularBoard sector.board then
                    Just sector.coordinate
                else
                    m_sector_low
            ) Nothing board

        updated_board =
            case m_blocked_sector of
                Just sector_low ->
                    Array.map (\sector ->
                        { sector |
                            board = 
                                Array.map (\sector_2 ->
                                    if sector_2.coordinate == sector_low && sector_2.state == SectorAttribute.Free then
                                        { sector_2 | state = SectorAttribute.Blocked }
                                    else
                                        sector_2
                                ) sector.board
                        }
                    ) board

                Nothing ->
                    board
    in
    updated_board

checkForBlockRegularBoard : BaseBoard.RegularBoard -> Bool
checkForBlockRegularBoard board =
    Array.filter (\i -> i.state /= SectorAttribute.Free) board
        |> Array.length
        |> (\i -> i == Array.length board)

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