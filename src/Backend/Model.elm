module Backend.Model exposing (..)

import Random
import Types.Storage.Storage as Storage


type alias BackendModel =
    { seed : Random.Seed
    , user_store : Storage.UserStore
    , game_store : Storage.GameStore
    }
