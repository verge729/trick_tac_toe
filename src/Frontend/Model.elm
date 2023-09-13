module Frontend.Model exposing (..)

import Browser.Navigation exposing (Key)
import Types.Coordinates as Coordinates
import Types.Board as Board
import Types.Player as Player
import Types.Victory as Victory
import Types.Events as Events
import Random
import Types.Storage.User as User
import Types.Storage.Game as StorageGame

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
    , list_events : List Events.Event
    , seed : Random.Seed
    , user : Maybe User.User
    , game : Maybe StorageGame.Game
    , user_games : List StorageGame.Game
    }