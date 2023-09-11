module Types.Coordinates exposing (..)

type alias Coordinates =
    { low : Sector       
    }

type Coordinate
    = Low Sector


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
    "Low : " ++ String.fromInt (toIntSector coordinates.low)

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