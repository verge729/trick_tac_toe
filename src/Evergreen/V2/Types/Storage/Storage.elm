module Evergreen.V2.Types.Storage.Storage exposing (..)

import Dict
import Evergreen.V2.Types.Storage.Game
import Evergreen.V2.Types.Storage.User


type alias UserStore =
    Dict.Dict String Evergreen.V2.Types.Storage.User.User


type alias GameStore =
    Dict.Dict String Evergreen.V2.Types.Storage.Game.Game
