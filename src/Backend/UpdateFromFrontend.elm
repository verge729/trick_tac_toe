module Backend.UpdateFromFrontend exposing (..)

import Dict
import Lamdera exposing (ClientId, SessionId)
import Types
import Types.Storage.Registration as Registration
import Lamdera
import Types.Storage.Response as Response
import Types.Storage.Auth as Auth


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
                    ( model
                    , Lamdera.sendToFrontend clientId (Types.LoginResponse <| Response.SuccessLogin user)
                    )

                Auth.Fail response ->
                    ( model
                    , Lamdera.sendToFrontend clientId (Types.LoginResponse <| Response.FailureLogin response)
                    )
