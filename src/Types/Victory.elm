module Types.Victory exposing (..)

import Types.Player as Player
import Types.Coordinates as Coordinates
import Types.Board as Board
import Array
import Types.Sector as Sector

type PathToVictory
    = Acheived Player.Player
    | Unacheived

checkVictory : Board.RegularBoard -> Player.Player -> PathToVictory
checkVictory board player_current =
    let
        claimed_player_current =
            Array.filter (\sector -> sector.state == Sector.Claimed player_current) board
                |> Array.toList
                |> List.map (\sector -> Coordinates.toIntSector sector.coordinate)
                |> List.sort
                |> List.map (\sector -> Coordinates.toSectorFromInt sector)

        claimed_victory =
            checkVictoryHorizontal claimed_player_current
                |> checkVictoryVertical claimed_player_current
                |> checkVictoryDiagonal claimed_player_current
    in
    if claimed_victory then
        Acheived player_current
    else
        Unacheived

checkVictoryHorizontal : List Coordinates.Sector -> Bool
checkVictoryHorizontal list_sector =
    let
        top = list_sector == horizontalVictoryGroups.top
        mid = list_sector == horizontalVictoryGroups.mid
        bottom = list_sector == horizontalVictoryGroups.bottom 
    in
    top || mid || bottom

checkVictoryVertical : List Coordinates.Sector -> Bool -> Bool
checkVictoryVertical list_sector claimed =
    if claimed then
        claimed 
    else
        let
            left = list_sector == verticalVictoryGroups.left
            center = list_sector == verticalVictoryGroups.center
            right = list_sector == verticalVictoryGroups.right 
        in
        left || center || right

checkVictoryDiagonal : List Coordinates.Sector -> Bool -> Bool
checkVictoryDiagonal list_sector claimed =
    if claimed then
        claimed 
    else
        let
            left_to_right = list_sector == diagonalVictoryGroups.left_to_right
            right_to_left = list_sector == diagonalVictoryGroups.right_to_left
        in
        left_to_right || right_to_left


type alias VictoryGrouping =
    List Coordinates.Sector

type alias Horizontal =
    { top : VictoryGrouping
    , mid : VictoryGrouping
    , bottom : VictoryGrouping        
    }

type alias Vertical =
    { left : VictoryGrouping
    , center : VictoryGrouping
    , right : VictoryGrouping        
    }

type alias Diagonal =
    { left_to_right : VictoryGrouping
    , right_to_left : VictoryGrouping
    }

horizontalVictoryGroups : Horizontal
horizontalVictoryGroups =
    { top = [ Coordinates.Zero, Coordinates.One, Coordinates.Two ]
    , mid = [ Coordinates.Three, Coordinates.Four, Coordinates.Five ]
    , bottom = [ Coordinates.Six, Coordinates.Seven, Coordinates.Eight ]        
    }

verticalVictoryGroups : Vertical
verticalVictoryGroups =
    { left = [ Coordinates.Zero, Coordinates.Three, Coordinates.Six ]
    , center = [ Coordinates.One, Coordinates.Four, Coordinates.Seven ]
    , right = [ Coordinates.Two, Coordinates.Five, Coordinates.Eight ]        
    }

diagonalVictoryGroups : Diagonal
diagonalVictoryGroups =
    { left_to_right = [ Coordinates.Zero, Coordinates.Four, Coordinates.Eight ]
    , right_to_left = [ Coordinates.Two, Coordinates.Four, Coordinates.Six ]
    }