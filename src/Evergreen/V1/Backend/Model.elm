module Evergreen.V1.Backend.Model exposing (..)

import Evergreen.V1.Types.Storage.Storage
import Random


type alias BackendModel =
    { seed : Random.Seed
    , user_store : Evergreen.V1.Types.Storage.Storage.UserStore
    , game_store : Evergreen.V1.Types.Storage.Storage.GameStore
    }
