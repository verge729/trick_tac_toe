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
import Backend.Utils as Utils


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
                        updated_user = { user | state = Connectivity.Connected clientId }
                        updated_user_store =
                            Dict.insert user.handle updated_user model.user_store

                        updated_connectivity =
                            Utils.updateConnectivityOnGames user model.game_store

                        clients_to_update =
                            Game.getFullGames updated_connectivity user
                                |> Utils.clientsToUpdateGames user


                        cmds =
                            List.map
                                (\( client, player ) ->
                                    Lamdera.sendToFrontend client (Types.RequestGamesResponse (Response.SuccessRequestGames <| Game.getGames updated_connectivity player))
                                )
                                clients_to_update
                    in
                    ( { model
                        | game_store = updated_connectivity
                        , user_store = updated_user_store
                      }
                    , Cmd.batch
                        (List.append
                            [ Lamdera.sendToFrontend clientId (Types.LoginResponse <| Response.SuccessLogin updated_user)
                            , Lamdera.sendToFrontend clientId (Types.RequestGamesResponse (Response.SuccessRequestGames <| Game.getGames updated_connectivity user))
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
                    let
                        updated_dict =
                            Dict.insert (Game.getId game.id) game model.game_store

                        updated_connectivity =
                            Utils.updateConnectivityOnGames reqs.player_two model.game_store

                        -- _ = Debug.log "updated_connectivity" updated_connectivity
                        full_games =
                            Game.getFullGames updated_connectivity reqs.player_two

                        clients_to_update =
                            full_games
                                |> Utils.clientsToUpdateGames reqs.player_two

                        cmds =
                            List.map
                                (\( client, player ) ->
                                    Lamdera.sendToFrontend client (Types.RequestGamesResponse (Response.SuccessRequestGames <| Game.getGames updated_connectivity player))
                                )
                                clients_to_update
                    in
                    ( { model | game_store = updated_dict }
                    , Cmd.batch
                        (List.append
                            [ Lamdera.sendToFrontend clientId (Types.JoinGameResponse <| Response.SuccessJoinGame game)
                            , Lamdera.sendToFrontend clientId (Types.RequestGamesResponse <| Response.SuccessRequestGames (Game.getGames updated_dict reqs.player_two))
                            ]
                            cmds
                        )
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



