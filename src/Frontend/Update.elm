module Frontend.Update exposing (..)

import Array
import Browser
import Browser.Navigation as Nav
import Types
import Types.Base.Board as BaseBoard
import Types.Base.Sector as Sector
import Types.Board as Board
import Types.Coordinates as Coordinates
import Types.Player as Player
import Types.SectorAttribute as SectorAttribute
import Types.Victory as Victory
import Url
import Frontend.UI.DataPanel exposing (coordinates)


update : Types.FrontendMsg -> Types.FrontendModel -> ( Types.FrontendModel, Cmd Types.FrontendMsg )
update msg model =
    case msg of
        Types.UrlClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model
                    , Nav.pushUrl model.key (Url.toString url)
                    )

                Browser.External url ->
                    ( model
                    , Nav.load url
                    )

        Types.UrlChanged url ->
            ( model, Cmd.none )

        Types.NoOpFrontendMsg ->
            ( model, Cmd.none )

        Types.NextCoordinateLowHover m_sector ->
            case m_sector of
                Just sector ->
                    ( { model | next_coordinate_low = m_sector }
                    , Cmd.none
                    )

                Nothing ->
                    ( { model | next_coordinate_low = Nothing }
                    , Cmd.none
                    )

        Types.NextCoordinateMidHover m_sector ->
            case m_sector of
                Just sector ->
                    ( { model | next_coordinate_mid = m_sector }
                    , Cmd.none
                    )

                Nothing ->
                    ( { model | next_coordinate_mid = Nothing }
                    , Cmd.none
                    )

        Types.ClaimSector sector ->
            case model.board of
                Board.NotSelected ->
                    ( model
                    , Cmd.none
                    )

                Board.Regular board ->
                    -- sector
                    -- current player in model
                    -- board in model
                    -- update sector in board
                    -- advance/swap current player
                    let
                        int_sector =
                            Coordinates.toIntSector sector.coordinate

                        m_target_sector =
                            Array.get int_sector board
                    in
                    case m_target_sector of
                        Just target_sector ->
                            let
                                updated_target_sector =
                                    { target_sector | state = SectorAttribute.Claimed model.current_player }

                                updated_board =
                                    Array.set int_sector updated_target_sector board

                                claimed_victory =
                                    Victory.checkVictory updated_board model.current_player
                            in
                            ( { model
                                | board = Board.Regular updated_board
                                , path_to_victory = claimed_victory
                                , current_player =
                                    if model.current_player == Player.defaultOne then
                                        Player.defaultTwo

                                    else
                                        Player.defaultOne
                              }
                            , Cmd.none
                            )

                        Nothing ->
                            ( model
                            , Cmd.none
                            )

                Board.Ultimate board ->
                    -- get current player
                    -- get ultimate sector
                    -- get low sector
                    -- update low sector
                    -- update ultimate sector
                    -- advance/swap current player
                    let
                        next_low = 
                            Maybe.withDefault Coordinates.Zero model.next_coordinate_low
                        next_mid =
                            Maybe.withDefault Coordinates.Zero model.next_coordinate_mid

                        coordinates =
                            { low = next_low, mid = next_mid }

                        updated_board =
                            updateUltimateBoard coordinates model.current_player board

                        claimed_victory =
                            Victory.checkVictory 
                                (updated_board) 
                                model.current_player
                    in
                    ( { model |
                        board = Board.Ultimate updated_board
                        , current_player =
                            if model.current_player == Player.defaultOne then
                                Player.defaultTwo

                            else
                                Player.defaultOne
                        , current_coordinate = Just coordinates
                        , path_to_victory = claimed_victory
                      }
                    , Cmd.none
                    )

updateUltimateBoard : Coordinates.Coordinates -> Player.Player -> Board.UltimateBoard -> Board.UltimateBoard
updateUltimateBoard coordinates current_player board =
    let
        int_sector =
            Coordinates.toIntSector coordinates.mid
    in
    case Array.get int_sector board of
        Just board_low ->
            let
                (updated_board, claimed_victory) =
                    updateBoard coordinates.low current_player board_low.board

                updated_ultimate_sector =
                    { board_low | board = updated_board, state = Victory.toStatePathToVictory claimed_victory }
            in
            Array.set int_sector updated_ultimate_sector board

        Nothing ->
            let
                _ = Debug.log "updateUltimateBoard : Nothing branch" 0
            in 
            board

updateBoard : Coordinates.Sector -> Player.Player -> Board.RegularBoard -> (Board.RegularBoard, Victory.PathToVictory)
updateBoard coordinate current_player board =
    -- sector
    -- current player in model
    -- board in model
    -- update sector in board
    -- advance/swap current player
    let
        int_sector =
            Coordinates.toIntSector coordinate

        m_target_sector =
            Array.get int_sector board
    in
    case m_target_sector of
        Just target_sector ->
            let
                updated_target_sector =
                    { target_sector | state = SectorAttribute.Claimed current_player }

                updated_board =
                    Array.set int_sector updated_target_sector board

                claimed_victory =
                    Victory.checkVictory updated_board current_player
            in
            (updated_board, claimed_victory)

        Nothing ->
            let
                _ = Debug.log "updateBoard : Nothing branch" 0
            in 
            (board, Victory.Unacheived)