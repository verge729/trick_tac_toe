module Types.Tricks.TrickHandlers exposing
    ( TrickHandler
    , handleTrick
    )

import Array
import Random
import Types.Base.Board as BaseBoard
import Types.Board as Board
import Types.Coordinates as Coordinates
import Types.Player as Player
import Types.SectorAttribute as SectorAttribute
import Types.Tricks.Trick as Trick
import Types.Ultimate.Board as UltimateBoard
import Types.Victory as Victory



{- ANCHOR TrickHandler -}


type alias TrickHandlerSpecialized a b =
    { trick_type : Trick.TrickType
    , player : Player.Player
    , turn : Int
    , coordinates : b
    , board : a
    , seed : Random.Seed
    }


type alias TrickHandler =
    { trick_type : Trick.TrickType
    , player : Player.Player
    , turn : Int
    , coordinates : Coordinates.CoordinateSystem
    , board : Board.Board
    , seed : Random.Seed
    }


handleTrick : TrickHandler -> ( Board.Board, Random.Seed )
handleTrick handler_info =
    case ( handler_info.board, handler_info.coordinates ) of
        ( Board.Regular regular, Coordinates.Regular sector ) ->
            let
                ( updated_board, seed ) =
                    handleTrickRegular
                        { trick_type = handler_info.trick_type
                        , player = handler_info.player
                        , turn = handler_info.turn
                        , coordinates = sector
                        , board = regular
                        , seed = handler_info.seed
                        }
            in
            ( Board.Regular updated_board, seed )

        ( Board.Ultimate ultimate, Coordinates.Ultimate coordinates ) ->
            let
                ( ( updated_board, claimed_victory ), seed ) =
                    handleTrickUltimate
                        { trick_type = handler_info.trick_type
                        , player = handler_info.player
                        , turn = handler_info.turn
                        , coordinates = coordinates
                        , board = ultimate
                        , seed = handler_info.seed
                        }
            in
            ( Board.Ultimate updated_board, seed )

        _ ->
            ( handler_info.board, handler_info.seed )



{- ANCHOR handle ultimate -}


handleTrickUltimate : TrickHandlerSpecialized Board.UltimateBoard Coordinates.Coordinates -> ( ( Board.UltimateBoard, Victory.PathToVictory ), Random.Seed )
handleTrickUltimate handler_info =
    (case handler_info.trick_type of
        Trick.Vanish ->
            ( ( handler_info.board, Victory.Unacheived ), handler_info.seed )

        Trick.WrongDestination ->
            let
                new_coordinates =
                    Coordinates.generateRandomCoordinates handler_info.seed

                ( coordinate, seed ) =
                    findFreeCoordinateUltimate handler_info.board new_coordinates.coordinates new_coordinates.seed
            in
            ( UltimateBoard.updateBoard
                handler_info.board
                coordinate
                (SectorAttribute.Claimed handler_info.player)
                handler_info.player
            , seed
            )
    )
        |> removeTrickUltimate handler_info.coordinates


removeTrickUltimate : Coordinates.Coordinates -> ( ( Board.UltimateBoard, Victory.PathToVictory ), Random.Seed ) -> ( ( Board.UltimateBoard, Victory.PathToVictory ), Random.Seed )
removeTrickUltimate coordinate ( ( board, claimed_victory ), seed ) =
    let
        int_coordinate =
            Coordinates.toIntSector coordinate.mid

        m_target_sector =
            Array.get int_coordinate board

        ( updated_board, n_seed ) =
            case m_target_sector of
                Just target_sector ->
                    let
                        ( new_board, new_seed ) =
                            removeTrickRegular coordinate.low ( target_sector.board, seed )
                    in
                    ( Array.set
                        int_coordinate
                        { target_sector | board = new_board }
                        board
                    , new_seed
                    )

                Nothing ->
                    ( board, seed )
    in
    ( ( updated_board, claimed_victory ), n_seed )


findFreeCoordinateUltimate : Board.UltimateBoard -> Coordinates.Coordinates -> Random.Seed -> ( Coordinates.Coordinates, Random.Seed )
findFreeCoordinateUltimate board start_coordinate seed =
    let
        ( int_low, int_mid ) =
            ( Coordinates.toIntSector start_coordinate.low, Coordinates.toIntSector start_coordinate.mid )
    in
    case Array.get int_mid board of
        Just sector ->
            case Array.get int_low sector.board of
                Just sector_low ->
                    case sector_low.state of
                        SectorAttribute.Free ->
                            ( start_coordinate, seed )

                        _ ->
                            let
                                n_coord =
                                    Coordinates.generateRandomCoordinates seed
                            in
                            findFreeCoordinateUltimate board { start_coordinate | mid = n_coord.coordinates.mid, low = n_coord.coordinates.low } n_coord.seed

                Nothing ->
                    ( start_coordinate, seed )

        Nothing ->
            ( start_coordinate, seed )



{- ANCHOR handler regular -}


handleTrickRegular : TrickHandlerSpecialized Board.RegularBoard Coordinates.Sector -> ( Board.RegularBoard, Random.Seed )
handleTrickRegular handler_info =
    (case handler_info.trick_type of
        Trick.Vanish ->
            ( handler_info.board, handler_info.seed )

        Trick.WrongDestination ->
            let
                ( sector, seed ) =
                    findFreeCoordinateRegular handler_info.board handler_info.coordinates handler_info.seed
            in
            ( BaseBoard.updateBoard
                handler_info.board
                sector
                (SectorAttribute.Claimed handler_info.player)
            , seed
            )
    )
        |> removeTrickRegular handler_info.coordinates


removeTrickRegular : Coordinates.Sector -> ( Board.RegularBoard, Random.Seed ) -> ( Board.RegularBoard, Random.Seed )
removeTrickRegular coordinate ( board, seed ) =
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
    ( updated_board, seed )


findFreeCoordinateRegular : Board.RegularBoard -> Coordinates.Sector -> Random.Seed -> ( Coordinates.Sector, Random.Seed )
findFreeCoordinateRegular board start_coordinate seed =
    let
        int_sector =
            Coordinates.toIntSector start_coordinate
    in
    case Array.get int_sector board of
        Just sector ->
            case sector.state of
                SectorAttribute.Free ->
                    ( start_coordinate, seed )

                _ ->
                    let
                        ( new_sector, new_seed ) =
                            Random.step Coordinates.randomGeneratorSector seed
                    in
                    findFreeCoordinateRegular board new_sector new_seed

        Nothing ->
            ( start_coordinate, seed )
