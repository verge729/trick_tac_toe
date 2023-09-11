module Parts.Coordinates exposing (..)

type alias Coordinates =
    { low : Coordinate       
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