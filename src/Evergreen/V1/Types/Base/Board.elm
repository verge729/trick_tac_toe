module Evergreen.V1.Types.Base.Board exposing (..)

import Array
import Evergreen.V1.Types.Base.Sector


type alias RegularBoard =
    Array.Array Evergreen.V1.Types.Base.Sector.Sector
