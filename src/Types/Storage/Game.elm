module Types.Storage.Game exposing (..)

import Random
import Types.Board as Board
import Types.Events as Event
import Types.Player as Player
import Types.Storage.IdGenerator as IdGenerator
import Dict
import Types.Storage.User as User
import Types.Base.Board as BaseBoard
import Types.Ultimate.Board as UltimateBoard

type GameId
    = GameId String


type JoinGameResult
    = Success Game
    | Fail String

type UpdateGameResult
    = Updated (Dict.Dict String Game)
    | Failed String


type alias Game =
    { id : GameId
    , board : Board.Board
    , player_one : User.User
    , player_two : Maybe User.User
    , current_player : User.User
    , turn : Int
    , event_log : List Event.Event
    , game_name : String
    }

type alias GameCreationReqs =
    { board : Board.Board
    , player_one : User.User  
    , game_name : String      
    }

type alias GameJoinReqs =
    { game_id : String
    , player_two : User.User
    } 

type alias CreateGame =
    { name : String
    , board : Board.SelectBoard
    }

createGame : Random.Seed -> GameCreationReqs -> ( Game, Random.Seed )
createGame seed reqs =
    let
        game_id =
            IdGenerator.generateIdGame seed
    in
    ( { id = GameId game_id.id
      , board = reqs.board
      , player_one = reqs.player_one
      , player_two = Nothing
      , current_player = reqs.player_one
      , turn = 0
      , event_log = []
      , game_name = reqs.game_name
      }
    , game_id.next_seed
    )

testGameWaiting : Random.Seed -> (Game, Random.Seed)
testGameWaiting seed =
    let
        game_id =
            IdGenerator.generateIdGame seed
    in
    ( { id = GameId game_id.id
      , board = Board.Ultimate <| Tuple.first UltimateBoard.boardUltimate
      , player_one = User.testing
      , player_two = Nothing--Just User.testingAgain
      , current_player = User.testing
      , turn = 0
      , event_log = []
      , game_name = "Waiting"
      }
    , game_id.next_seed
    )

testGameConnected : Random.Seed -> (Game, Random.Seed)
testGameConnected seed =
    let
        game_id =
            IdGenerator.generateIdGame seed
    in
    ( { id = GameId game_id.id
      , board = Board.Ultimate <| Tuple.first UltimateBoard.boardUltimate
      , player_one = User.testing
      , player_two = Just User.testingAgain
      , current_player = User.testing
      , turn = 0
      , event_log = []
      , game_name = "Connected"
      }
    , game_id.next_seed
    )

testGameDisconnected : Random.Seed -> (Game, Random.Seed)
testGameDisconnected seed =
    let
        game_id =
            IdGenerator.generateIdGame seed
    in
    ( { id = GameId game_id.id
      , board = Board.Ultimate <| Tuple.first UltimateBoard.boardUltimate
      , player_one = User.testing
      , player_two = Just User.testingAgainDC
      , current_player = User.testing
      , turn = 0
      , event_log = []
      , game_name = "Disconnected"
      }
    , game_id.next_seed
    )

testGame : Random.Seed -> (Game, Random.Seed)
testGame seed =
    let
        game_id =
            IdGenerator.generateIdGame seed
    in
    ( { id = GameId game_id.id
      , board = Board.Regular <| Tuple.first BaseBoard.boardRegular
      , player_one = User.testing
      , player_two = Just User.testingAgain
      , current_player = User.testing
      , turn = 0
      , event_log = []
      , game_name = "Freedom"
      }
    , game_id.next_seed
    )


getId : GameId -> String
getId (GameId id) =
    id

getGames : Dict.Dict String Game -> User.User -> List Game
getGames games user =
    Dict.values games
        |> List.filter (\game -> game.player_one == user || game.player_two == Just user)

getFullGames : Dict.Dict String Game -> User.User -> List Game
getFullGames games user =
    getGames games user
        |> List.filter (\game -> game.player_two /= Nothing)

joinGame : Dict.Dict String Game -> GameJoinReqs -> JoinGameResult
joinGame games reqs =
    let
        m_game =
            Dict.get reqs.game_id games
    in
    case m_game of
        Just game ->
            case game.player_two of
                Nothing ->
                    Success
                        { game
                            | player_two = Just reqs.player_two
                        }

                Just _ ->
                    Fail "Game is full"

        Nothing ->
            Fail "Game not found"


updateGame : Dict.Dict String Game -> Game -> UpdateGameResult
updateGame games game =
    let
        m_game =
            Dict.get (getId game.id) games
    in
    case m_game of
        Just _ ->
            Updated (Dict.insert (getId game.id) game games)

        Nothing ->
            Failed "Game not found"
