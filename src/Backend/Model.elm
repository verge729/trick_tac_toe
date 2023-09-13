module Backend.Model exposing (..)


import Types.Storage.Storage as Storage
import Random

type alias BackendModel = 
    { seed : Random.Seed  
    , user_store : Storage.UserStore
    , game_store : Storage.GameStore      
    }