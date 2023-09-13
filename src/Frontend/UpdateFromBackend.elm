module Frontend.UpdateFromBackend exposing (..)

import Types
import Types.Storage.Response as Response
import Types.Storage.Response as Response

updateFromBackend : Types.ToFrontend -> Types.FrontendModel -> ( Types.FrontendModel, Cmd Types.FrontendMsg )
updateFromBackend msg model =
    case msg of
        Types.NoOpToFrontend ->
            ( model, Cmd.none )

        Types.RegistrationResponse response ->
            case response of
                Response.SuccessRegistration user ->
                    ( { model | user = Just user }
                    , Cmd.none
                    )

                Response.FailureRegistration error ->
                    ( model, Cmd.none)

        Types.LoginResponse response ->
            case response of
                Response.SuccessLogin user ->
                    ( { model | user = Just user }
                    , Cmd.none
                    )

                Response.FailureLogin error ->
                    ( model, Cmd.none)