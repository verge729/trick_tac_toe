module Frontend.Model exposing (..)

import Browser.Navigation exposing (Key)
import Types.Coordinates as Coordinates
import Types.Board as Board
import Types.Player as Player
import Types.Victory as Victory
import Types.Events as Events
import Random

type alias FrontendModel =
    { key : Key
    , message : String 
    , current_coordinate : Maybe Coordinates.Coordinates
    , next_coordinate_low : Maybe Coordinates.Sector
    , next_coordinate_mid : Maybe Coordinates.Sector
    , board : Board.Board
    , player_one : Player.Player
    , player_two : Player.Player
    , current_player : Player.Player
    , path_to_victory : Victory.PathToVictory
    , turn : Int
    , list_events_regular : List (Events.Event Coordinates.Sector)
    , list_events_ultimate : List (Events.Event Coordinates.Coordinates)
    , random_list_sectors : List Coordinates.Sector
    , seed : Random.Seed
    }