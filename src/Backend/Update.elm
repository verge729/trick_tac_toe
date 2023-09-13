module Backend.Update exposing (update)

import Types 


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
            ( model, Cmd.none )