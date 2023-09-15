module Types.Storage.Response exposing (..)

import Types.Storage.Game as Game
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


type CreateGame
    = SuccessCreateGame Game.Game
    | FailureCreateGame String


type RequestGames
    = SuccessRequestGames (List Game.Game)
    | FailureRequestGames String


type JoinGame
    = SuccessJoinGame Game.Game
    | FailureJoinGame String


type UpdateGame
    = SuccessUpdateGame Game.Game
    | FailureUpdateGame String
