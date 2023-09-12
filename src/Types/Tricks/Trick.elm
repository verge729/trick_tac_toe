module Types.Tricks.Trick exposing
    ( Trick
    , TrickType(..)
    , getTrickFromType
    , randomGeneratorRegular
    , randomGeneratorUltimate
    , toString
    )

import Random


type TrickType
    = Vanish
    | WrongDestination


randomGeneratorUltimate : Random.Generator (List TrickType)
randomGeneratorUltimate =
    randomGeneratorList 18 27 randomGeneratorTrick


randomGeneratorRegular : Random.Generator (List TrickType)
randomGeneratorRegular =
    randomGeneratorList 1 3 randomGeneratorTrick


randomGeneratorList : Int -> Int -> Random.Generator TrickType -> Random.Generator (List TrickType)
randomGeneratorList start end generator =
    Random.int start end
        |> Random.andThen
            (\length ->
                Random.list length generator
            )


randomGeneratorTrick : Random.Generator TrickType
randomGeneratorTrick =
    Random.uniform Vanish [ WrongDestination ]


type alias Trick =
    { trick_type : TrickType
    , description : String
    , triggered : Bool
    }


getTrickFromType : TrickType -> Trick
getTrickFromType trickType =
    case trickType of
        Vanish ->
            vanish

        WrongDestination ->
            wrongDestination


toString : Trick -> String
toString trick =
    case trick.trick_type of
        Vanish ->
            "Vanish"

        WrongDestination ->
            "Wrong Destination"


vanish : Trick
vanish =
    { trick_type = Vanish
    , description = "Vanish"
    , triggered = False
    }


wrongDestination : Trick
wrongDestination =
    { trick_type = WrongDestination
    , description = "Wrong Destination"
    , triggered = False
    }
