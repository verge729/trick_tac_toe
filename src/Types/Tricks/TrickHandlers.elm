module Types.Tricks.TrickHandlers exposing (..)

import Types.Tricks.Trick as Trick
import Types.Board as Board
import Types.Player as Player
import Types.Coordinates as Coordinates
import Types.Base.Board as BaseBoard
import Types.SectorAttribute as SectorAttribute
import Array

type alias TrickHandler a =
    { trick_type : Trick.TrickType
    , player : Player.Player
    , turn : Int
    , coordinates : Coordinates.Sector
    , board : a        
    }

handleTrickRegular : TrickHandler Board.RegularBoard -> Board.RegularBoard
handleTrickRegular handler_info =
    ( case handler_info.trick_type of
        Trick.Vanish ->
            handler_info.board

        Trick.WrongDestination ->
            BaseBoard.updateBoard 
                handler_info.board 
                (findFreeCoordinate handler_info.board handler_info.coordinates) 
                (SectorAttribute.Claimed handler_info.player)
    ) |> removeTrick handler_info.coordinates

removeTrick : Coordinates.Sector -> Board.RegularBoard -> Board.RegularBoard
removeTrick coordinate board =
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
                { target_sector | content = SectorAttribute.Clear } 
                board

        Nothing ->
            board

findFreeCoordinate : Board.RegularBoard -> Coordinates.Sector -> Coordinates.Sector
findFreeCoordinate board start_coordinate =
    let
        int_sector =
            Coordinates.toIntSector start_coordinate
    in
    case Array.get int_sector board of
        Just sector ->
            case sector.content of
                SectorAttribute.Clear ->
                    start_coordinate

                _ ->
                    findFreeCoordinate board (Coordinates.toSectorFromInt <| modBy 9 (int_sector + 1))

        Nothing ->
            start_coordinate

changeCoordinate : Coordinates.Sector -> Coordinates.Sector
changeCoordinate sector =
    case sector of
        Coordinates.Zero ->
            Coordinates.Seven
        
        Coordinates.One ->
            Coordinates.Five

        Coordinates.Two ->
            Coordinates.Eight

        Coordinates.Three ->
            Coordinates.Zero

        Coordinates.Four ->
            Coordinates.One

        Coordinates.Five ->
            Coordinates.Two

        Coordinates.Six ->
            Coordinates.Six

        Coordinates.Seven ->
            Coordinates.Four

        Coordinates.Eight ->    
            Coordinates.Four