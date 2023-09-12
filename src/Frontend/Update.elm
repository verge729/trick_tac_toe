module Frontend.Update exposing (..)

import Array
import Browser
import Browser.Navigation as Nav
import Types
import Types.Base.Board as Board
import Types.Base.Sector as Sector
import Types.Board as Board
import Types.Coordinates as Coordinates
import Types.Player as Player
import Types.SectorAttribute as SectorAttribute
import Types.Victory as Victory
import Url


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
                    ( model
                    , Cmd.none
                    )
