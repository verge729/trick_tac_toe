module Frontend exposing (..)

import Browser exposing (UrlRequest(..))
import Browser.Navigation as Nav
import Html
import Html.Attributes as Attr
import Lamdera
import Types exposing (..)
import Url
import Types.Board as Board
import Types.Base.Board as BaseBoard
import Frontend.UI.Home as Home
import Frontend.Update as FrontendUpdate
import Frontend.UpdateFromBackend as UpdateFromBackend
import Html.Styled as HS
import Html.Styled.Attributes as HSA
import Types.Player as Player
import Types.Victory as Victory
import Types.Ultimate.Board as UltimateBoard
import Task
import Random
import Types.Coordinates as Coordinates
import Types.Tricks.Trick as Trick

type alias Model =
    FrontendModel


app =
    Lamdera.frontend
        { init = init
        , onUrlRequest = UrlClicked
        , onUrlChange = UrlChanged
        , update = FrontendUpdate.update
        , updateFromBackend = UpdateFromBackend.updateFromBackend
        , subscriptions = \m -> Sub.none
        , view = view 
        }


init : Url.Url -> Nav.Key -> ( Model, Cmd FrontendMsg )
init url key =
    ( { key = key
      , message = "Welcome to Lamdera! You're looking at the auto-generated base implementation. Check out src/Frontend.elm to start coding!"
      , current_coordinate = Nothing
      , next_coordinate_low = Nothing
      , next_coordinate_mid = Nothing
    --   , board = Board.Ultimate UltimateBoard.boardUltimate
      , board = Board.NotSelected--Board.Regular <| BaseBoard.addTricks BaseBoard.boardRegular
      , player_one = Player.defaultOne
      , player_two = Player.defaultTwo
      , current_player = Player.defaultOne
    --   , path_to_victory = Victory.Acheived Player.defaultOne
      , path_to_victory = Victory.Unacheived 
      , turn = 0
      , list_events = []
      , random_list_sectors = []
      , seed = Random.initialSeed 42
      }
    , Random.generate Types.CatchRandomGeneratorSeed Random.independentSeed
    -- Cmd.batch 
    --     [ Random.generate Types.CatchRandomGeneratorSector Coordinates.randomGenerator
    --     , Random.generate Types.CatchRandomGeneratorTrick Trick.randomGeneratorRegular
    --     ]
    )



view : Model -> Browser.Document FrontendMsg
view model =
    { title = "Trick Tac Toe"
    , body =
        [ HS.toUnstyled <|
           Home.root model
        ]
    }