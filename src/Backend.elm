module Backend exposing (..)

import Backend.Update as BackendUpdate
import Backend.UpdateFromFrontend as BackendUpdateFromFrontend
import Dict
import Lamdera exposing (ClientId, SessionId)
import Random
import Types exposing (..)


type alias Model =
    Types.BackendModel


app =
    Lamdera.backend
        { init = init
        , update = BackendUpdate.update
        , updateFromFrontend = BackendUpdateFromFrontend.updateFromFrontend
        , subscriptions = subscriptions
        }


init : ( Model, Cmd BackendMsg )
init =
    ( { seed = Random.initialSeed 42
      , game_store = Dict.empty
      , user_store = Dict.empty
      }
    , Random.generate Types.CatchRandomGeneratorSeedBE Random.independentSeed
    )


subscriptions : Model -> Sub BackendMsg
subscriptions model =
    Sub.batch
        [ Lamdera.onConnect Types.ClientConnected
        , Lamdera.onDisconnect Types.ClientDisconnected
        ]
