module Backend.Update exposing (update)

import Types 


update : Types.BackendMsg -> Types.BackendModel -> ( Types.BackendModel, Cmd Types.BackendMsg )
update msg model =
    case msg of
        Types.NoOpBackendMsg ->
            ( model, Cmd.none )