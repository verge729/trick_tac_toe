module Types.Storage.IdGenerator exposing (..)

import Random

type alias Response =
    { id : String       
    , next_seed : Random.Seed 
    }

{-| This generates a random number that contains 10 digits and converts it to a string. `Random.mxInt` is equivalent to 2147483647 according to the docs at https://package.elm-lang.org/packages/elm/random/latest/Random
-}
generateIdString : Random.Seed -> Response
generateIdString seed =
    let
        lower_range =
            Random.maxInt - 1147483647

        (result, next_seed) =
            Random.step (Random.int lower_range Random.maxInt) seed
    in
    Response
        (String.fromInt result)
        next_seed

