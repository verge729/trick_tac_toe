module Types.Base.Sector exposing (..)

import Types.Coordinates as Coordinates
import Types.Player as Player
import Types.SectorAttribute as SectorAttribute


type alias Sector =
    { state : SectorAttribute.State
    , content : SectorAttribute.Content
    , coordinate : Coordinates.Sector
    }


defaultSector : Coordinates.Sector -> Sector
defaultSector coordinate =
    { state = SectorAttribute.Free
    , content = SectorAttribute.Clear
    , coordinate = coordinate
    }


updateState : Player.Player -> Sector -> Sector
updateState player sector =
    { sector | state = SectorAttribute.Claimed player }
