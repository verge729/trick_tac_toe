module Types.Storage.Game exposing (..)

import Types.Board as Board
import Types.Player as Player
import Types.Events as Event

type GameId
    = GameId String

type alias Game =
    { id : GameId
    , board : Board.Board
    , player_one : Player.Player
    , player_two : Player.Player
    , current_player : Player.Player
    , turn : Int 
    , event_log : List Event.Event   
    }

generateGameId : GameId
generateGameId =
    GameId "1234"