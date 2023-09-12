module Types.Tricks.TrickHandlers exposing (..)

import Types.Tricks.Trick as Trick
import Types.Board as Board
import Types.Player as Player
import Types.Coordinates as Coordinates
import Types.Base.Board as BaseBoard
import Types.SectorAttribute as SectorAttribute
import Array
import Random

type alias TrickHandler a =
    { trick_type : Trick.TrickType
    , player : Player.Player
    , turn : Int
    , coordinates : Coordinates.Sector
    , board : a     
    , seed : Random.Seed   
    }

handleTrickRegular : TrickHandler Board.RegularBoard -> (Board.RegularBoard, Random.Seed)
handleTrickRegular handler_info =
    ( case handler_info.trick_type of
        Trick.Vanish ->
            (handler_info.board, handler_info.seed)

        Trick.WrongDestination ->
            let
                (sector, seed) =
                    findFreeCoordinate handler_info.board handler_info.coordinates handler_info.seed
            in
            ( BaseBoard.updateBoard 
                handler_info.board 
                sector
                (SectorAttribute.Claimed handler_info.player)
            , seed
            )   
    ) |> removeTrick handler_info.coordinates

removeTrick : Coordinates.Sector -> (Board.RegularBoard, Random.Seed) -> (Board.RegularBoard, Random.Seed)
removeTrick coordinate (board, seed) =
    let
        int_sector =
            Coordinates.toIntSector coordinate

        m_target_sector =
            Array.get int_sector board

        updated_board =
            case m_target_sector of
                Just target_sector ->
                    Array.set 
                        int_sector 
                        { target_sector | content = SectorAttribute.Clear } 
                        board

                Nothing ->
                    board
    in 
    (updated_board, seed)

findFreeCoordinate : Board.RegularBoard -> Coordinates.Sector -> Random.Seed -> (Coordinates.Sector, Random.Seed)
findFreeCoordinate board start_coordinate seed =
    let
        int_sector =
            Coordinates.toIntSector start_coordinate
    in
    case Array.get int_sector board of
        Just sector ->
            case sector.state of
                SectorAttribute.Free ->
                    (start_coordinate, seed)

                _ ->
                    let
                        (new_sector, new_seed) =
                            Random.step Coordinates.randomGeneratorSector seed
                    in
                    findFreeCoordinate board new_sector new_seed

        Nothing ->
            (start_coordinate, seed)