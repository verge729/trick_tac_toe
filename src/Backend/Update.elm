module Backend.Update exposing (update)

import Backend.Utils as Utils
import Dict
import Lamdera
import Types
import Types.Storage.Connectivity as Connectivity
import Types.Storage.Game as Game
import Types.Storage.Response as Response


update : Types.BackendMsg -> Types.BackendModel -> ( Types.BackendModel, Cmd Types.BackendMsg )
update msg model =
    case msg of
        Types.NoOpBackendMsg ->
            ( model, Cmd.none )

        Types.CatchRandomGeneratorSeedBE seed ->
            ( { model | seed = seed }, Cmd.none )

        Types.ClientConnected session_id client_id ->
            ( model, Cmd.none )

        Types.ClientDisconnected session_id client_id ->
            let
                m_user =
                    Dict.values model.user_store
                        |> List.filter (\user -> user.state == Connectivity.Connected client_id)
                        |> List.head
            in
            case m_user of
                Just user ->
                    let
                        updated_user =
                            { user | state = Connectivity.Disconnected }

                        updated_user_store =
                            Dict.insert updated_user.handle updated_user model.user_store

                        updated_game_store =
                            Utils.updateConnectivityOnGames updated_user model.game_store

                        clients_to_update =
                            Utils.clientsToUpdateGames updated_user (Dict.values updated_game_store)

                        cmds =
                            List.map
                                (\( client, player ) ->
                                    Lamdera.sendToFrontend client (Types.RequestGamesResponse (Response.SuccessRequestGames <| Game.getGames updated_game_store player))
                                )
                                clients_to_update
                    in
                    ( { model
                        | user_store = updated_user_store
                        , game_store = updated_game_store
                      }
                    , Cmd.batch cmds
                    )

                Nothing ->
                    ( model, Cmd.none )
