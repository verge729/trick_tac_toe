module Types.Storage.Auth exposing (..)

import Dict
import Types.Storage.User as User


type Authenicated
    = Pass User.User
    | Fail String


type alias AuthReqs =
    { handle : String
    , keyphrase : String
    }


authenticateUser : Dict.Dict String User.User -> AuthReqs -> Authenicated
authenticateUser dict_users reqs =
    case Dict.get reqs.handle dict_users of
        Just user ->
            compareKeyphrase user reqs.keyphrase

        Nothing ->
            Fail "User not found"


compareKeyphrase : User.User -> String -> Authenicated
compareKeyphrase user submitted_phrase =
    if user.keyphrase == submitted_phrase then
        Pass user

    else
        Fail "Incorrect keyphrase"
