module Evergreen.V2.Types.Base.Board exposing (..)

import Array
import Evergreen.V2.Types.Base.Sector


type alias RegularBoard =
    Array.Array Evergreen.V2.Types.Base.Sector.Sector
