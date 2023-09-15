module Types.Storage.Storage exposing (..)

import Dict
import Types.Storage.Game as Game
import Types.Storage.User as User


type alias UserStore =
    Dict.Dict String User.User


type alias GameStore =
    Dict.Dict String Game.Game
