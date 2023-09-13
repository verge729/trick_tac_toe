module Types.Storage.Response exposing (..)

import Types.Storage.User as User

type Base 
    = Success String
    | Failure String

type Registration 
    = SuccessRegistration User.User
    | FailureRegistration String

type Login
    = SuccessLogin User.User
    | FailureLogin String