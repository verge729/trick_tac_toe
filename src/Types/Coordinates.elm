module Types.Coordinates exposing (..)

import Random

randomGeneratorUltimate : Random.Generator (List Sector)
randomGeneratorUltimate =
    randomGeneratorList 3 8 randomGeneratorSector

randomGeneratorRegular : Random.Generator (List Sector)
randomGeneratorRegular =
    randomGeneratorList 1 3 randomGeneratorSector

randomGeneratorList : Int -> Int -> Random.Generator Sector -> Random.Generator (List Sector)
randomGeneratorList start end generator =
    Random.int start end
        |> Random.andThen
            (\length ->
                Random.list length generator
            )


randomGeneratorSector : Random.Generator Sector
randomGeneratorSector =
    Random.uniform Zero [ One, Two, Three, Four, Five, Six, Seven, Eight ]

type alias RandomCoordinates =
    { coordinates : Coordinates
    , seed : Random.Seed       
    }

generateRandomCoordinates : Random.Seed -> RandomCoordinates
generateRandomCoordinates seed =
    let
        (low, seed1) =
            Random.step randomGeneratorSector seed

        (mid, seed2) =
            Random.step randomGeneratorSector seed1
    in
    { coordinates = { low = low, mid = mid }, seed = seed2 }

type alias Coordinates =
    { low : Sector
    , mid : Sector
    }


type Level
    = Low
    | Mid

type CoordinateSystem 
    = Regular Sector
    | Ultimate Coordinates

type Sector
    = Zero
    | One
    | Two
    | Three
    | Four
    | Five
    | Six
    | Seven
    | Eight


toStringCoordinates : Coordinates -> String
toStringCoordinates coordinates =
    "Low : "
        ++ String.fromInt (toIntSector coordinates.low)
        ++ "\n"
        ++ "Mid : "
        ++ String.fromInt (toIntSector coordinates.mid)
        ++ "\n"


toIntSector : Sector -> Int
toIntSector sector =
    case sector of
        Zero ->
            0

        One ->
            1

        Two ->
            2

        Three ->
            3

        Four ->
            4

        Five ->
            5

        Six ->
            6

        Seven ->
            7

        Eight ->
            8


toCharSector : Sector -> Char
toCharSector sector =
    case sector of
        Zero ->
            '0'

        One ->
            '1'

        Two ->
            '2'

        Three ->
            '3'

        Four ->
            '4'

        Five ->
            '5'

        Six ->
            '6'

        Seven ->
            '7'

        Eight ->
            '8'


toStringSector : Sector -> String
toStringSector sector =
    case sector of
        Zero ->
            "0"

        One ->
            "1"

        Two ->
            "2"

        Three ->
            "3"

        Four ->
            "4"

        Five ->
            "5"

        Six ->
            "6"

        Seven ->
            "7"

        Eight ->
            "8"


toSectorFromInt : Int -> Sector
toSectorFromInt int =
    case int of
        0 ->
            Zero

        1 ->
            One

        2 ->
            Two

        3 ->
            Three

        4 ->
            Four

        5 ->
            Five

        6 ->
            Six

        7 ->
            Seven

        8 ->
            Eight

        _ ->
            Zero
