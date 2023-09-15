module Frontend.UpdateFromBackend exposing (..)

import Lamdera
import Types
import Types.Coordinates as Coordinates
import Types.Navigation as Navigation
import Types.Storage.Response as Response
import Types.Player as Player
import Types.Storage.Game as Game

updateFromBackend : Types.ToFrontend -> Types.FrontendModel -> ( Types.FrontendModel, Cmd Types.FrontendMsg )
updateFromBackend msg model =
    case msg of
        Types.NoOpToFrontend ->
            ( model, Cmd.none )

        Types.RegistrationResponse response ->
            case response of
                Response.SuccessRegistration user ->
                    ( { model
                        | user = Just user
                        , view_full_area = Navigation.Authenticated
                      }
                    , Cmd.none
                    )

                Response.FailureRegistration error ->
                    ( { model | m_error_message = Just error }
                    , Cmd.none
                    )

        Types.LoginResponse response ->
            case response of
                Response.SuccessLogin user ->
                    ( { model
                        | user = Just user
                        , view_full_area = Navigation.Authenticated
                      }
                    , Cmd.none
                    )

                Response.FailureLogin error ->
                    ( { model | m_error_message = Just error }
                    , Cmd.none
                    )

        Types.CreateGameRespnse response ->
            case response of
                Response.SuccessCreateGame game ->
                    case model.user of
                        Just user ->
                            ( { model | game = Just game }
                            , Lamdera.sendToBackend <| Types.RequestGames user
                            )

                        Nothing ->
                            ( { model
                                | game = Just game
                                , m_error_message = Just "User not logged in"
                              }
                            , Cmd.none
                            )

                Response.FailureCreateGame error ->
                    ( { model | m_error_message = Just error }
                    , Cmd.none
                    )

        Types.RequestGamesResponse response ->
            case response of
                Response.SuccessRequestGames games ->
                    let
                        ( m_game, coordinates, sector ) =
                            case model.game of
                                Just game ->
                                    List.foldl
                                        (\g ( m_g, m_g_coordinates, m_g_sector ) ->
                                            if g.id == game.id then
                                                case g.current_coordinate of
                                                    Just stuff ->
                                                        case stuff of
                                                            Coordinates.Ultimate coords ->
                                                                ( Just g, Just coords, Nothing )

                                                            Coordinates.Regular sect ->
                                                                ( Just g, Nothing, Just sect )

                                                    Nothing ->
                                                        ( Just g, Nothing, Nothing )

                                            else
                                                ( m_g, m_g_coordinates, m_g_sector )
                                        )
                                        ( Nothing, Nothing, Nothing )
                                        games

                                Nothing ->
                                    ( model.game, model.current_coordinate, model.next_coordinate_mid )

                                

                        ( player_one, player_two, current_player ) =
                            case m_game of
                                Just game ->
                                    let
                                        created_p_one =
                                            Player.createPlayerOne game.player_one
                                    in
                                    case game.player_two of
                                        Just p_two ->
                                            let
                                                created_p_two =
                                                    Player.createPlayerTwo p_two

                                                current_p =
                                                    Player.getPlayerFromUser created_p_one created_p_two game.current_player

                                            in                                    
                                            ( created_p_one
                                            , created_p_two
                                            , current_p
                                            )
                                        Nothing ->
                                            ( created_p_one
                                            , Player.defaultTwo
                                            , created_p_one
                                            )

                                Nothing ->
                                    ( Player.defaultOne
                                    , Player.defaultTwo 
                                    , Player.defaultOne
                                    )
                    in
                    ( { model
                        | user_games = Game.separateGames games
                        , game = m_game
                        , current_coordinate = coordinates
                        , player_one = player_one
                        , player_two = player_two
                        , current_player = current_player
                        , next_coordinate_mid = sector
                      }
                    , Cmd.none
                    )

                Response.FailureRequestGames error ->
                    ( { model | m_error_message = Just error }
                    , Cmd.none
                    )

        Types.JoinGameResponse response ->
            case response of
                Response.SuccessJoinGame game ->
                    ( { model | game = Just game }
                    , Cmd.none
                    )

                Response.FailureJoinGame error ->
                    ( { model | m_error_message = Just error }
                    , Cmd.none
                    )

        Types.UpdateGameResponse response ->
            case response of
                Response.SuccessUpdateGame game ->
                    ( { model | game = Just game }
                    , Cmd.none
                    )

                Response.FailureUpdateGame error ->
                    ( { model | m_error_message = Just error }
                    , Cmd.none
                    )
