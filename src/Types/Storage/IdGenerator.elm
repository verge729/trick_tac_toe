module Types.Storage.IdGenerator exposing 
    ( generateIdGame
    , generateIdUser
    , Response        
    )

import Random

type alias Response =
    { id : String       
    , next_seed : Random.Seed 
    }

userRange : Int
userRange =
    1147483647

gameRange : Int
gameRange =
    1000000000

{-| This generates a random number that contains 10 digits and converts it to a string. `Random.mxInt` is equivalent to 2147483647 according to the docs at https://package.elm-lang.org/packages/elm/random/latest/Random
-}
generateIdUser : Random.Seed -> Response
generateIdUser seed =
    generateId seed (Random.maxInt - userRange) Random.maxInt

generateIdGame : Random.Seed -> Response
generateIdGame seed =
    generateId seed (userRange - gameRange) userRange


generateId : Random.Seed -> Int -> Int -> Response
generateId seed lower upper =
    let
        (result, next_seed) =
            Random.step (Random.int lower upper) seed
    in
    Response
        (String.fromInt result)
        next_seed
