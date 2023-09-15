module Evergreen.V1.Types.Storage.Storage exposing (..)

import Dict
import Evergreen.V1.Types.Storage.Game
import Evergreen.V1.Types.Storage.User


type alias UserStore =
    Dict.Dict String Evergreen.V1.Types.Storage.User.User


type alias GameStore =
    Dict.Dict String Evergreen.V1.Types.Storage.Game.Game
