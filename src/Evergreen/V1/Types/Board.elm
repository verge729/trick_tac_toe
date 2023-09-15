module Evergreen.V1.Types.Board exposing (..)

import Array
import Evergreen.V1.Types.Base.Sector
import Evergreen.V1.Types.Ultimate.Sector


type alias RegularBoard =
    Array.Array Evergreen.V1.Types.Base.Sector.Sector


type alias UltimateBoard =
    Array.Array Evergreen.V1.Types.Ultimate.Sector.Sector


type Board
    = NotSelected
    | Regular RegularBoard
    | Ultimate UltimateBoard


type SelectBoard
    = SelectRegular
    | SelectUltimate
