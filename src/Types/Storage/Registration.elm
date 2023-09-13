module Types.Storage.Registration exposing (..)

import Dict
import Types.Storage.User as User
import Types.Storage.IdGenerator as IdGenerator
import Types.Storage.Auth as Auth
import Random
import Types.Storage.Connectivity as Connectivity

type Register 
    = Success User.User
    | Failure String

checkHandle : Dict.Dict String User.User -> Auth.AuthReqs -> String -> Random.Seed -> (Register, Random.Seed)
checkHandle dict_users reqs client_id seed =
    let
        handle_exists =
            Dict.keys dict_users
                |> List.filter (\key -> key == reqs.handle)
                |> List.length
                |> (\x -> x > 0)
            -- Dict.values dict_users
            --     |> List.filter (\user -> user.handle == reqs.handle)
            --     |> List.length
            --     |> (\x -> x > 0)
    in 
    if handle_exists then
        (Failure "Handle already exists", seed)
    else
        let
            id = IdGenerator.generateIdUser seed
        in
        ( Success 
            { handle = reqs.handle
            , keyphrase = reqs.keyphrase
            , id = id.id 
            , state = Connectivity.Connected client_id
            }
        , id.next_seed
        )