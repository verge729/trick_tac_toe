module Backend.Utils exposing (..)

import Types.Storage.User as User
import Types.Storage.Game as Game
import Lamdera exposing (ClientId)
import Types.Storage.Connectivity as Connectivity
import Dict
import Types.Storage.Storage as Storage

clientsToUpdateGames : User.User -> List Game.Game -> List ( ClientId, User.User )
clientsToUpdateGames user list_games =
    List.foldl
        (\game clients ->
            case game.player_two of
                Just player_two ->
                    if player_two.handle == user.handle then
                        case game.player_one.state of
                            Connectivity.Connected client ->
                                ( client, game.player_one ) :: clients

                            Connectivity.Disconnected ->
                                clients

                    else
                        case player_two.state of
                            Connectivity.Connected client ->
                                ( client, player_two ) :: clients

                            Connectivity.Disconnected ->
                                clients

                Nothing ->
                    clients
        )
        []
        list_games
        |>
            List.foldl
                (\( client, player ) clients ->
                    if List.member ( client, player ) clients then
                        clients

                    else
                        ( client, player ) :: clients
                )
                []

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