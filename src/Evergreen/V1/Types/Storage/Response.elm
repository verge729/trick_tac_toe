module Evergreen.V1.Types.Storage.Response exposing (..)

import Evergreen.V1.Types.Storage.Game
import Evergreen.V1.Types.Storage.User


type Registration
    = SuccessRegistration Evergreen.V1.Types.Storage.User.User
    | FailureRegistration String


type Login
    = SuccessLogin Evergreen.V1.Types.Storage.User.User
    | FailureLogin String


type CreateGame
    = SuccessCreateGame Evergreen.V1.Types.Storage.Game.Game
    | FailureCreateGame String


type RequestGames
    = SuccessRequestGames (List Evergreen.V1.Types.Storage.Game.Game)
    | FailureRequestGames String


type JoinGame
    = SuccessJoinGame Evergreen.V1.Types.Storage.Game.Game
    | FailureJoinGame String


type UpdateGame
    = SuccessUpdateGame Evergreen.V1.Types.Storage.Game.Game
    | FailureUpdateGame String
