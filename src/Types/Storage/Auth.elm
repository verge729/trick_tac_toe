module Types.Storage.Auth exposing (..)

import Types.Storage.User as User
import Dict

type Authenicated 
    = Pass User.User
    | Fail String

type alias AuthReqs =
    { handle : String
    , keyphrase : String        
    }

findUser : Dict.Dict String User.User -> String -> Authenicated
findUser dict_users username =
    Fail "WIP - findUser"

compareKeyphrase : User.User -> String -> Authenicated
compareKeyphrase user submitted_phrase =
    Fail "WIP - compareKeyphrase"