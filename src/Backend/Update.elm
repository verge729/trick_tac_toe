module Backend.Update exposing (update)

import Types 
import Types.Storage.User as User
import Types.Storage.Game as Game
import Lamdera exposing (ClientId)
import Types.Storage.Connectivity as Connectivity
import Types.Storage.Storage as Storage
import Dict
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
                            Dict.insert user.handle updated_user model.user_store
                        updated_game_store =
                            updateConnectivityOnGames updated_user model.game_store

                        clients_to_update =
                            clientsToUpdateGames updated_user (Dict.values updated_game_store)

                        cmds =
                            List.map
                                (\( client, player ) ->
                                    Lamdera.sendToFrontend client (Types.RequestGamesResponse (Response.SuccessRequestGames <| Game.getGames model.game_store player))
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