module Types.Victory exposing (PathToVictory(..), checkVictory, toStringPathToVictory, toPathToVictoryState, toStatePathToVictory)

{-| This module is responsible for checking if a player has won the game.
-}

import Types.Player as Player
import Types.Coordinates as Coordinates
import Types.Base.Board as Board
import Array
import Types.Base.Sector as Sector
import Types.SectorAttribute as SectorAttribute
import Types.Board as Board


type PathToVictory
    = Acheived Player.Player
    | Unacheived

toStatePathToVictory : PathToVictory -> SectorAttribute.State
toStatePathToVictory path_to_victory =
    case path_to_victory of
        Acheived player ->
            SectorAttribute.Claimed player

        Unacheived ->
            SectorAttribute.Free

toPathToVictoryState : SectorAttribute.State -> PathToVictory
toPathToVictoryState state =
    case state of
        SectorAttribute.Claimed player ->
            Acheived player

        _ ->
            Unacheived

checkVictory : Board.Board -> Player.Player -> PathToVictory
checkVictory board player =
    case board of
        Board.Regular regular ->
            checkVictory1 regular player

        Board.Ultimate ultimate ->
            checkVictory1 ultimate player

        Board.NotSelected ->
            Unacheived

checkVictory1 : Array.Array { a | state : SectorAttribute.State, coordinate : Coordinates.Sector } -> Player.Player -> PathToVictory
checkVictory1 board player_current =
    let
        claimed_player_current =
            Array.filter (\sector -> sector.state == SectorAttribute.Claimed player_current) board
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
        top = compareLists list_sector horizontalVictoryGroups.top
        mid = compareLists list_sector horizontalVictoryGroups.mid
        bottom = compareLists list_sector horizontalVictoryGroups.bottom 
    in
    top || mid || bottom

checkVictoryVertical : List Coordinates.Sector -> Bool -> Bool
checkVictoryVertical list_sector claimed =
    if claimed then
        claimed 
    else
        let
            left = compareLists list_sector verticalVictoryGroups.left
            center = compareLists list_sector verticalVictoryGroups.center
            right = compareLists list_sector verticalVictoryGroups.right 
        in
        left || center || right

checkVictoryDiagonal : List Coordinates.Sector -> Bool -> Bool
checkVictoryDiagonal list_sector claimed =
    if claimed then
        claimed 
    else
        let
            left_to_right = compareLists list_sector diagonalVictoryGroups.left_to_right
            right_to_left = compareLists list_sector diagonalVictoryGroups.right_to_left
        in
        left_to_right || right_to_left

compareLists : List Coordinates.Sector -> List Coordinates.Sector -> Bool
compareLists claimed victory =
    List.foldl (\sector acheived ->
        if List.member sector claimed then
            acheived
        else
            False
    ) True victory

toStringPathToVictory : PathToVictory -> String
toStringPathToVictory path_to_victory =
    case path_to_victory of
        Acheived player ->
            "Player " ++ player.handle ++ " has won the game!"

        Unacheived ->
            "No one has won the game yet."

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