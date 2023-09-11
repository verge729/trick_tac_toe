module Backend.UpdateFromFrontend exposing (..)

import Lamdera exposing (ClientId, SessionId)
import Types

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