module Evergreen.V1.Types.Storage.Game exposing (..)

import Evergreen.V1.Types.Board
import Evergreen.V1.Types.Coordinates
import Evergreen.V1.Types.Events
import Evergreen.V1.Types.Storage.User
import Evergreen.V1.Types.Victory


type GameId
    = GameId String


type alias Game =
    { id : GameId
    , board : Evergreen.V1.Types.Board.Board
    , player_one : Evergreen.V1.Types.Storage.User.User
    , player_two : Maybe Evergreen.V1.Types.Storage.User.User
    , current_player : Evergreen.V1.Types.Storage.User.User
    , turn : Int
    , event_log : List Evergreen.V1.Types.Events.Event
    , game_name : String
    , path_to_victory : Evergreen.V1.Types.Victory.PathToVictory
    , current_coordinate : Maybe Evergreen.V1.Types.Coordinates.CoordinateSystem
    }


type alias GameTypes =
    { active : List Game
    , waiting : List Game
    , finished : List Game
    }


type alias GameCreationReqs =
    { board : Evergreen.V1.Types.Board.Board
    , player_one : Evergreen.V1.Types.Storage.User.User
    , game_name : String
    }


type alias GameJoinReqs =
    { game_id : String
    , player_two : Evergreen.V1.Types.Storage.User.User
    }
