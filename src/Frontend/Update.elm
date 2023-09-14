module Frontend.Update exposing (..)

import Array
import Browser
import Browser.Navigation as Nav
import Engine.Engine as Engine
import Types
import Types.Base.Board as BaseBoard
import Types.Base.Sector as Sector
import Types.Board as Board
import Types.Coordinates as Coordinates
import Types.Player as Player
import Types.SectorAttribute as SectorAttribute
import Types.Ultimate.Board as UltimateBoard
import Types.Victory as Victory
import Url
import Lamdera
import Types.Storage.Game as StorageGame
import Types.Navigation as Navigation


type alias UpdateTurn =
    { player_one : Player.Player
    , player_two : Player.Player
    , current_player : Player.Player
    , current_turn : Int
    }


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

        Types.GameViewAreaNavTo target ->
            ( { model | view_game_area = target }
            , Cmd.none
            )

        Types.SelectGame game_id ->
            let
                m_game =
                    List.foldl (\game selected ->
                        if game.id == game_id then
                            Just game

                        else
                            selected
                    ) Nothing model.user_games
            in
            ( { model | game = m_game 
            , view_game_area = Navigation.Game
            , view_data_panel = Navigation.GameDetails
            }
            , Cmd.none
            )

        Types.CatchRandomGeneratorSeedFE seed ->
            let
                ( board, max_turns ) =
                    -- BaseBoard.boardRegular
                    UltimateBoard.boardUltimate

                ( tricked_board, new_seed ) =
                    -- BaseBoard.addTricks board seed
                    UltimateBoard.addTricks board seed
            in
            ( { model
                | seed = new_seed
                -- , board = Board.Ultimate tricked_board
              }
            , Cmd.none
            )

        Types.Login ->
            case (model.login_register_handle, model.login_register_keyphrase) of
                (Just handle, Just keyphrase) ->
                    let
                        auth_reqs =
                            { handle = handle
                            , keyphrase = keyphrase
                            }
                    in 
                    ( model
                    , Lamdera.sendToBackend <| Types.LoginUser auth_reqs
                    )

                (Just _, Nothing) ->
                    ( { model | m_error_message = Just "Missing keyphrase" }
                    , Cmd.none
                    )

                (Nothing, Just _ ) ->
                    ( { model | m_error_message = Just "Missing handle"}
                    , Cmd.none
                    )

                _ ->
                    ( { model | m_error_message = Just "Missing handle and keyphrase"}
                    , Cmd.none
                    )

        Types.Register ->
            case (model.login_register_handle, model.login_register_keyphrase) of
                (Just handle, Just keyphrase) ->
                    let
                        auth_reqs =
                            { handle = handle
                            , keyphrase = keyphrase
                            }
                    in 
                    ( model
                    , Lamdera.sendToBackend <| Types.AddUser auth_reqs
                    )

                (Just _, Nothing) ->
                    ( { model | m_error_message = Just "Missing keyphrase" }
                    , Cmd.none
                    )

                (Nothing, Just _ ) ->
                    ( { model | m_error_message = Just "Missing handle"}
                    , Cmd.none
                    )

                _ ->
                    ( { model | m_error_message = Just "Missing handle and keyphrase"}
                    , Cmd.none
                    )

        Types.FillHandler str ->
            let
                value =
                    if str == "" then
                        Nothing

                    else
                        Just str
            in 
            ( { model | login_register_handle = value }
            , Cmd.none
            )

        Types.FillGameName str ->
            let
                value =
                    if str == "" then
                        Nothing

                    else
                        Just str
            in 
            ( { model | game_creation_name = value }
            , Cmd.none
            )

        Types.SelectBoard select_board ->
            case model.game_creation_board of
                Just board ->
                    let
                        submission =
                            if board == select_board then
                                Nothing

                            else
                                Just select_board
                    in
                    ( { model | game_creation_board = submission }
                    , Cmd.none
                    )

                Nothing ->
                    ( { model | game_creation_board = Just select_board }
                    , Cmd.none
                    )

        Types.FillKeyphrase str ->
            let
                value =
                    if str == "" then
                        Nothing

                    else
                        Just str
                    
            in 
            ( { model | login_register_keyphrase = value }
            , Cmd.none
            )

        Types.SubmitGameCreation ->
            case (model.game_creation_name, model.game_creation_board) of
                (Just name, Just board) ->
                    case model.user of
                        Just user ->
                            let
                                (selected_board, new_seed) =
                                    case board of
                                        Board.SelectRegular ->
                                                let
                                                    (b, s) =
                                                        BaseBoard.addTricks (Tuple.first BaseBoard.boardRegular) model.seed
                                                in 
                                                (Board.Regular b, s)

                                        Board.SelectUltimate ->
                                                let
                                                    (b, s) =
                                                        UltimateBoard.addTricks (Tuple.first UltimateBoard.boardUltimate) model.seed
                                                in 
                                                (Board.Ultimate b, s)
                                                 

                                game_creation_reqs =
                                    { game_name = name
                                    , board = selected_board
                                    , player_one = user
                                    }
                            in
                            ( {model | seed = new_seed }
                            , Lamdera.sendToBackend <| Types.CreateGame game_creation_reqs 
                            )

                        Nothing ->
                            ( { model | m_error_message = Just "Missing user" }
                            , Cmd.none
                            )

                (Just _, Nothing) ->
                    ( { model | m_error_message = Just "Missing board" }
                    , Cmd.none
                    )

                (Nothing, Just _ ) ->
                    ( { model | m_error_message = Just "Missing name"}
                    , Cmd.none
                    )

                _ ->
                    ( { model | m_error_message = Just "Missing name and board"}
                    , Cmd.none
                    )

        Types.NextCoordinateLowHover m_sector ->
            ( { model | next_coordinate_low = m_sector }
            , Cmd.none
            )

        Types.NextCoordinateMidHover m_sector ->
            ( { model | next_coordinate_mid = m_sector }
            , Cmd.none
            )

        Types.ClaimSector sector ->
            let
                other_player =
                    if model.current_player == model.player_one then
                        model.player_two

                    else
                        model.player_one
            in
            case model.game of
                Nothing ->
                    ( model
                    , Cmd.none
                    )

                Just game ->
                    case game.board of
                        Board.NotSelected ->
                            ( model
                            , Cmd.none
                            )

                        Board.Regular board ->
                            let
                                processed_claim =
                                    Engine.processTurn
                                        (Engine.Claim
                                            model.current_player
                                            other_player
                                            sector
                                            (Coordinates.Regular sector.coordinate)
                                            model.turn
                                            (Board.Regular board)
                                            model.seed
                                        )
                            in
                            ( updateModelwithProcessedClaim processed_claim model
                            , Cmd.none
                            )

                        Board.Ultimate board ->
                            let
                                next_low =
                                    Maybe.withDefault Coordinates.Zero model.next_coordinate_low

                                next_mid =
                                    Maybe.withDefault Coordinates.Zero model.next_coordinate_mid

                                coordinates =
                                    { low = next_low, mid = next_mid }

                                processed_claim =
                                    Engine.processTurn
                                        (Engine.Claim
                                            model.current_player
                                            other_player
                                            sector
                                            (Coordinates.Ultimate coordinates)
                                            model.turn
                                            (Board.Ultimate board)
                                            model.seed
                                        )
                            in
                            ( { model
                                | current_coordinate = Just { coordinates | mid = next_low }
                            }
                                |> updateModelwithProcessedClaim processed_claim
                            , Cmd.none
                            )



updateModelwithProcessedClaim : Engine.ClaimResult -> Types.FrontendModel -> Types.FrontendModel
updateModelwithProcessedClaim claim_result model =
    { model
        | turn = claim_result.turn
        , board = claim_result.board
        , current_player = claim_result.next_player
        , path_to_victory = claim_result.path_to_victory
        , list_events = claim_result.event :: model.list_events
    }
