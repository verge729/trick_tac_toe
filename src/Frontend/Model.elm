module Frontend.Model exposing (..)

import Browser.Navigation exposing (Key)
import Random
import Types.Board as Board
import Types.Coordinates as Coordinates
import Types.Events as Events
import Types.Navigation as Navigation
import Types.Player as Player
import Types.Storage.Game as StorageGame
import Types.Storage.User as User
import Types.Victory as Victory


type alias FrontendModel =
    { key : Key
    , current_coordinate : Maybe Coordinates.Coordinates
    , next_coordinate_low : Maybe Coordinates.Sector
    , next_coordinate_mid : Maybe Coordinates.Sector
    , player_one : Player.Player
    , player_two : Player.Player
    , current_player : Player.Player
    , path_to_victory : Victory.PathToVictory
    , turn : Int
    , list_events : List Events.Event
    , seed : Random.Seed
    , user : Maybe User.User
    , game : Maybe StorageGame.Game
    , user_games : StorageGame.GameTypes
    , view_data_panel : Navigation.DataPanel
    , view_game_area : Navigation.GameArea
    , view_full_area : Navigation.FullView
    , login_register_handle : Maybe String
    , login_register_keyphrase : Maybe String
    , m_error_message : Maybe String
    , game_creation_name : Maybe String
    , game_creation_board : Maybe Board.SelectBoard
    , m_join_code : Maybe String
    }
