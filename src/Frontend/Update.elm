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

        Types.DataPanelNavTo target ->
            ( { model | view_data_panel = target }
            , Cmd.none
            )

        Types.SelectGame game_id ->
            let
                (m_game, path_to_victory) =
                    List.foldl (\game selected ->
                        if game.id == game_id then
                            (Just game, game.path_to_victory)

                        else
                            selected
                    ) (Nothing, Victory.Unacheived) (StorageGame.combineGames model.user_games)


                (m_coordinates, m_sector) =
                    case m_game of
                        Just game ->
                            case game.current_coordinate of
                                Just stuff ->
                                    case stuff of
                                        Coordinates.Ultimate coords ->
                                            (Just coords, Nothing)

                                        Coordinates.Regular sect ->
                                            (Nothing, Just sect)

                                Nothing ->
                                    (Nothing, Nothing)
                        Nothing ->
                            (Nothing, Nothing )

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
            ( { model | game = m_game 
            , view_game_area = Navigation.Game
            , view_data_panel = Navigation.GameDetails
            , player_one = player_one
            , player_two = player_two
            , current_player = current_player
            , current_coordinate = m_coordinates
            , path_to_victory = path_to_victory
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

        Types.FillJoinCode str ->
            let
                value =
                    if str == "" then
                        Nothing

                    else
                        Just str
            in 
            ( { model | m_join_code = value }
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

        Types.SubmitJoinGame ->
            case (model.m_join_code, model.user) of
                (Just code, Just user) -> 
                    let
                        join_reqs =
                            { game_id = code
                            , player_two = user
                            }
                    in  
                    ( model
                    , Lamdera.sendToBackend <| Types.JoinGame join_reqs
                    )

                (Nothing, Just _) ->  
                    ( { model | m_error_message = Just "Missing join code" }
                    , Cmd.none
                    )

                (Just _, Nothing) ->  
                    ( { model | m_error_message = Just "User not logged in" }
                    , Cmd.none
                    )

                _ ->  
                    ( { model | m_error_message = Just "User not logged in and missing join code" }
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
                    case game.player_two of
                        Just player_two ->
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
                                                    game.turn
                                                    (Board.Regular board)
                                                    model.seed
                                                )

                                        updated_game =
                                            updateGamewithProcessedClaim processed_claim game
                                    in
                                    ( { model | game = Just updated_game }
                                        |> updateModelwithProcessedClaim processed_claim 
                                    , Lamdera.sendToBackend <| Types.UpdateGame updated_game
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
                                                    game.turn
                                                    (Board.Ultimate board)
                                                    model.seed
                                                )

                                        current_coordinate =
                                            { coordinates | mid = next_low }

                                        updated_game =
                                            updateGamewithProcessedClaim processed_claim game
                                                |> (\g -> { g | current_coordinate = Just <| Coordinates.Ultimate current_coordinate })
                                    in
                                    ( { model
                                        | current_coordinate = Just current_coordinate
                                        , game = Just updated_game
                                        }
                                        |> updateModelwithProcessedClaim processed_claim
                                    , Lamdera.sendToBackend <| Types.UpdateGame updated_game
                                    )

                        Nothing ->
                            ( model
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

updateGamewithProcessedClaim : Engine.ClaimResult -> StorageGame.Game -> StorageGame.Game
updateGamewithProcessedClaim result game =
    let
        next_user =
            case game.player_two of
                Just player_two ->
                    Player.getUserFromPlayer game.player_one player_two result.next_player

                Nothing ->
                    game.player_one
    in
    { game
        | current_player = next_user
        , board = result.board
        , event_log = result.event :: game.event_log
        , turn = result.turn
        , path_to_victory = result.path_to_victory
    }
