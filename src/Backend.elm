module Backend exposing (..)

import Html
import Lamdera exposing (ClientId, SessionId)
import Types exposing (..)
import Backend.Update as BackendUpdate
import Backend.UpdateFromFrontend as BackendUpdateFromFrontend


type alias Model =
    Types.BackendModel


app =
    Lamdera.backend
        { init = init
        , update = BackendUpdate.update
        , updateFromFrontend = BackendUpdateFromFrontend.updateFromFrontend
        , subscriptions = \m -> Sub.none
        }


init : ( Model, Cmd BackendMsg )
init =
    ( { }
    , Cmd.none
    )
