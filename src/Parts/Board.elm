module Parts.Board exposing (..)

import Array
import Parts.Sector as Sector

boardRegular : Array.Array Sector.Sector
boardRegular =
    Array.initialize 9 (\_ -> Sector.Clear) 