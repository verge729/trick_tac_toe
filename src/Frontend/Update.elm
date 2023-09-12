module Frontend.Update exposing (..)

import Types
import Browser
import Browser.Navigation as Nav
import Url
import Types.Coordinates as Coordinates
import Types.Board as Board
import Array
import Types.Sector as Sector
import Types.Player as Player
import Types.Victory as Victory


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

        Types.NextCoordinateHover m_sector -> 
            case m_sector of
                Just sector ->
                    let
                        current_next_coordinate = model.next_coordinate
                        updated_next_coordinate =
                            case current_next_coordinate of
                                Nothing -> { low = sector }
                                Just next_coordinate -> 
                                    { next_coordinate | low = sector }
                    in 
                    ( {model | next_coordinate = Just updated_next_coordinate}
                    , Cmd.none
                    )

                Nothing ->
                    ( {model | next_coordinate = Nothing}
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
                        int_sector = Coordinates.toIntSector sector.coordinate
                        m_target_sector = Array.get int_sector board
                    in
                    case m_target_sector of
                        Just target_sector ->
                            let
                                updated_target_sector =
                                    { target_sector | state = Sector.Claimed model.current_player }
                                updated_board =
                                     (Array.set int_sector updated_target_sector board) 
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