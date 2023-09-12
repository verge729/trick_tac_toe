module Types.Board exposing (..)

import Types.Base.Board as BaseBoard
import Types.Ultimate.Board as UltimateBoard
import Array
import Types.Base.Sector as BaseSector
import Types.Ultimate.Sector as UltimateSector

type alias RegularBoard =
    Array.Array BaseSector.Sector

type alias UltimateBoard =
    Array.Array UltimateSector.Sector

type alias BoardRows a =
    { top : a
    , middle : a
    , bottom : a
    }

type Board
    = NotSelected
    | Regular RegularBoard
    | Ultimate UltimateBoard