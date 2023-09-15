module Evergreen.V2.Backend.Model exposing (..)

import Evergreen.V2.Types.Storage.Storage
import Random


type alias BackendModel =
    { seed : Random.Seed
    , user_store : Evergreen.V2.Types.Storage.Storage.UserStore
    , game_store : Evergreen.V2.Types.Storage.Storage.GameStore
    }
