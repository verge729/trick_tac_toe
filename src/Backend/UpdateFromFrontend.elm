module Backend.UpdateFromFrontend exposing (..)

import Dict
import Lamdera exposing (ClientId, SessionId)
import Types
import Types.Storage.Auth as Auth
import Types.Storage.Connectivity as Connectivity
import Types.Storage.Game as Game
import Types.Storage.Registration as Registration
import Types.Storage.Response as Response
import Types.Storage.Storage as Storage
import Types.Storage.User as User


updateFromFrontend :
    SessionId
    -> ClientId
    -> Types.ToBackend
    -> Types.BackendModel
    -> ( Types.BackendModel, Cmd Types.BackendMsg )
updateFromFrontend sessionId clientId msg model =
    case msg of
        Types.NoOpToBackend ->
            ( model, Cmd.none )

        Types.AddUser reqs ->
            let
                ( result, next_seed ) =
                    Registration.checkHandle model.user_store reqs clientId model.seed
            in
            case result of
                Registration.Success user ->
                    let
                        updated_dict =
                            Dict.insert user.handle user model.user_store
                    in
                    ( { model
                        | user_store = updated_dict
                        , seed = next_seed
                      }
                    , Lamdera.sendToFrontend clientId (Types.RegistrationResponse <| Response.SuccessRegistration user)
                    )

                Registration.Failure response ->
                    ( model
                    , Lamdera.sendToFrontend clientId (Types.RegistrationResponse <| Response.FailureRegistration response)
                    )

        Types.LoginUser reqs ->
            case Auth.authenticateUser model.user_store reqs of
                Auth.Pass user ->
                    let
                        updated_connectivity =
                            updateConnectivityOnGames user model.game_store

                        clients_to_update =
                            Game.getFullGames updated_connectivity user
                                |> clientsToUpdateGames user

                        cmds =
                            List.map
                                (\( client, player ) ->
                                    Lamdera.sendToFrontend client (Types.RequestGamesResponse (Response.SuccessRequestGames <| Game.getGames model.game_store player))
                                )
                                clients_to_update
                    in
                    ( { model | game_store = updated_connectivity }
                    , Cmd.batch
                        ( List.append
                            [ Lamdera.sendToFrontend clientId (Types.LoginResponse <| Response.SuccessLogin { user | state = Connectivity.Connected clientId })
                            , Lamdera.sendToFrontend clientId (Types.RequestGamesResponse (Response.SuccessRequestGames <| Game.getGames model.game_store user))
                            ]
                            cmds
                        )
                    )

                Auth.Fail response ->
                    ( model
                    , Lamdera.sendToFrontend clientId (Types.LoginResponse <| Response.FailureLogin response)
                    )

        Types.CreateGame reqs ->
            let
                ( result, next_seed ) =
                    Game.createGame model.seed reqs
            in
            ( { model
                | seed = next_seed
                , game_store = Dict.insert (Game.getId result.id) result model.game_store
              }
            , Lamdera.sendToFrontend clientId (Types.CreateGameRespnse <| Response.SuccessCreateGame result)
            )

        Types.RequestGames reqs ->
            let
                games =
                    Game.getGames model.game_store reqs
            in
            ( model
            , Lamdera.sendToFrontend clientId (Types.RequestGamesResponse <| Response.SuccessRequestGames games)
            )

        Types.JoinGame reqs ->
            case Game.joinGame model.game_store reqs of
                Game.Success game ->
                    ( { model | game_store = Dict.insert (Game.getId game.id) game model.game_store }
                    , Lamdera.sendToFrontend clientId (Types.JoinGameResponse <| Response.SuccessJoinGame game)
                    )

                Game.Fail error ->
                    ( model
                    , Lamdera.sendToFrontend clientId (Types.JoinGameResponse <| Response.FailureJoinGame error)
                    )

        Types.UpdateGame reqs ->
            case Game.updateGame model.game_store reqs of
                Game.Updated games ->
                    ( { model | game_store = games }
                    , Lamdera.sendToFrontend clientId (Types.UpdateGameResponse <| Response.SuccessUpdateGame reqs)
                    )

                Game.Failed error ->
                    ( model
                    , Lamdera.sendToFrontend clientId (Types.UpdateGameResponse <| Response.FailureUpdateGame error)
                    )


clientsToUpdateGames : User.User -> List Game.Game -> List ( ClientId, User.User )
clientsToUpdateGames user list_games =
    List.foldl
        (\game clients ->
            case game.player_two of
                Just player_two ->
                    if player_two.handle == user.handle then
                        clients

                    else
                        case player_two.state of
                            Connectivity.Connected client ->
                                ( client, player_two ) :: clients

                            Connectivity.Disconnected ->
                                clients

                Nothing ->
                    if game.player_one.handle == user.handle then
                        clients

                    else
                        case game.player_one.state of
                            Connectivity.Connected client ->
                                ( client, game.player_one ) :: clients

                            Connectivity.Disconnected ->
                                clients
        )
        []
        list_games


updateConnectivityOnGames : User.User -> Storage.GameStore -> Storage.GameStore
updateConnectivityOnGames user games =
    let
        updated_games_of_user =
            Game.getGames games user
                |> List.map
                    (\game ->
                        if game.player_one.handle == user.handle then
                            let
                                updated_user =
                                    game.player_one |> (\player -> { player | state = user.state })
                            in
                            { game | player_one = updated_user }

                        else
                            case game.player_two of
                                Just player_two ->
                                    let
                                        updated_user =
                                            player_two |> (\player -> { player | state = user.state })
                                    in
                                    { game | player_two = Just updated_user }

                                Nothing ->
                                    game
                    )
    in
    List.foldl
        (\game dict ->
            case Dict.get (Game.getId game.id) dict of
                Just _ ->
                    Dict.insert (Game.getId game.id) game dict

                Nothing ->
                    dict
        )
        games
        updated_games_of_user
