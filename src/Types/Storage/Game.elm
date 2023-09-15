module Types.Storage.Game exposing (..)

import Dict
import Random
import Types.Base.Board as BaseBoard
import Types.Board as Board
import Types.Coordinates as Coordinates
import Types.Events as Event
import Types.Storage.IdGenerator as IdGenerator
import Types.Storage.User as User
import Types.Ultimate.Board as UltimateBoard
import Types.Victory as Victory


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
    , path_to_victory : Victory.PathToVictory
    , current_coordinate : Maybe Coordinates.CoordinateSystem
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
      , path_to_victory = Victory.Unacheived
      , current_coordinate = Nothing
      }
    , game_id.next_seed
    )


testGameWaiting : Random.Seed -> ( Game, Random.Seed )
testGameWaiting seed =
    let
        game_id =
            IdGenerator.generateIdGame seed
    in
    ( { id = GameId game_id.id
      , board = Board.Ultimate <| Tuple.first UltimateBoard.boardUltimate
      , player_one = User.testing
      , player_two = Nothing 
      , current_player = User.testing
      , turn = 0
      , event_log = []
      , game_name = "Waiting"
      , path_to_victory = Victory.Unacheived
      , current_coordinate = Nothing
      }
    , game_id.next_seed
    )


testGameConnected : Random.Seed -> ( Game, Random.Seed )
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
      , path_to_victory = Victory.Unacheived
      , current_coordinate = Nothing
      }
    , game_id.next_seed
    )


testGameDisconnected : Random.Seed -> ( Game, Random.Seed )
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
      , path_to_victory = Victory.Unacheived
      , current_coordinate = Nothing
      }
    , game_id.next_seed
    )


testGame : Random.Seed -> ( Game, Random.Seed )
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
      , path_to_victory = Victory.Unacheived
      , current_coordinate = Nothing
      }
    , game_id.next_seed
    )


getId : GameId -> String
getId (GameId id) =
    id


getGames : Dict.Dict String Game -> User.User -> List Game
getGames games user =
    Dict.values games
        |> List.filter
            (\game ->
                let
                    player_two_id =
                        case game.player_two of
                            Just player ->
                                player.id

                            Nothing ->
                                ""
                in
                game.player_one.id == user.id || player_two_id == user.id
            )


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


type alias GameTypes =
    { active : List Game
    , waiting : List Game
    , finished : List Game
    }


separateGames : List Game -> GameTypes
separateGames list_games =
    let
        active =
            List.filter (\game -> game.player_two /= Nothing && game.path_to_victory == Victory.Unacheived) list_games

        waiting =
            List.filter (\game -> game.player_two == Nothing) list_games

        finished =
            List.filter (\game -> game.path_to_victory /= Victory.Unacheived) list_games
    in
    { active = active
    , waiting = waiting
    , finished = finished
    }


combineGames : GameTypes -> List Game
combineGames game_types =
    game_types.active ++ game_types.waiting ++ game_types.finished
