module Types.Sector exposing (..)

import Types.Player as Player
import Types.Coordinates as Coordinates

type Trick
    = Trick 

type Blessing
    = Blessing

type Content
    = Clear

type State 
    = Free
    | Claimed Player.Player

type alias Sector =
    { state : State
    , content : Content 
    , coordinate : Coordinates.Sector       
    }

defaultSector : Coordinates.Sector -> Sector
defaultSector coordinate =
    { state = Free
    , content = Clear
    , coordinate = coordinate
    }

updateState : Player.Player -> Sector -> Sector
updateState player sector =
    { sector | state = Claimed player }