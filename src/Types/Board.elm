module Types.Board exposing (..)

import Array
import Types.Base.Sector as BaseSector
import Types.Ultimate.Sector as UltimateSector
import Types.SectorAttribute as SectorAttribute

type alias RegularBoard =
    Array.Array BaseSector.Sector

type alias UltimateBoard =
    Array.Array UltimateSector.Sector

type alias BoardRows a =
    { top : a
    , middle : a
    , bottom : a
    }

type Board
    = NotSelected
    | Regular RegularBoard
    | Ultimate UltimateBoard

type SelectBoard 
    = SelectRegular
    | SelectUltimate

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

checkForBlockRegularBoard : RegularBoard -> Bool
checkForBlockRegularBoard board =
    Array.filter (\i -> i.state /= SectorAttribute.Free) board
        |> Array.length
        |> (\i -> i == Array.length board)

checkForBlockUltimateBoard : UltimateBoard -> Bool
checkForBlockUltimateBoard board =
    False