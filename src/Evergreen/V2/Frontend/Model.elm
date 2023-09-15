module Evergreen.V2.Frontend.Model exposing (..)

import Browser.Navigation
import Evergreen.V2.Types.Board
import Evergreen.V2.Types.Coordinates
import Evergreen.V2.Types.Events
import Evergreen.V2.Types.Navigation
import Evergreen.V2.Types.Player
import Evergreen.V2.Types.Storage.Game
import Evergreen.V2.Types.Storage.User
import Evergreen.V2.Types.Victory
import Random


type alias FrontendModel =
    { key : Browser.Navigation.Key
    , current_coordinate : Maybe Evergreen.V2.Types.Coordinates.Coordinates
    , next_coordinate_low : Maybe Evergreen.V2.Types.Coordinates.Sector
    , next_coordinate_mid : Maybe Evergreen.V2.Types.Coordinates.Sector
    , player_one : Evergreen.V2.Types.Player.Player
    , player_two : Evergreen.V2.Types.Player.Player
    , current_player : Evergreen.V2.Types.Player.Player
    , path_to_victory : Evergreen.V2.Types.Victory.PathToVictory
    , turn : Int
    , list_events : List Evergreen.V2.Types.Events.Event
    , seed : Random.Seed
    , user : Maybe Evergreen.V2.Types.Storage.User.User
    , game : Maybe Evergreen.V2.Types.Storage.Game.Game
    , user_games : Evergreen.V2.Types.Storage.Game.GameTypes
    , view_data_panel : Evergreen.V2.Types.Navigation.DataPanel
    , view_game_area : Evergreen.V2.Types.Navigation.GameArea
    , view_full_area : Evergreen.V2.Types.Navigation.FullView
    , login_register_handle : Maybe String
    , login_register_keyphrase : Maybe String
    , m_error_message : Maybe String
    , game_creation_name : Maybe String
    , game_creation_board : Maybe Evergreen.V2.Types.Board.SelectBoard
    , m_join_code : Maybe String
    }
