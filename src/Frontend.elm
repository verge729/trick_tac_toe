module Frontend exposing (..)

import Browser exposing (UrlRequest(..))
import Browser.Navigation as Nav
import Frontend.UI.Home as Home
import Frontend.Update as FrontendUpdate
import Frontend.UpdateFromBackend as UpdateFromBackend
import Html.Styled as HS
import Lamdera
import Random
import Types exposing (..)
import Types.Navigation as Navigation
import Types.Player as Player
import Types.Victory as Victory
import Url


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
      , current_coordinate = Nothing
      , next_coordinate_low = Nothing
      , next_coordinate_mid = Nothing
      , player_one = Player.defaultOne
      , player_two = Player.defaultTwo
      , current_player = Player.defaultOne
      , path_to_victory = Victory.Unacheived
      , turn = 0
      , list_events = []
      , seed = Random.initialSeed 42
      , user = Nothing
      , game = Nothing
      , user_games =
            { waiting = []
            , active = []
            , finished = []
            }
      , view_data_panel = Navigation.Menu
      , view_game_area = Navigation.GameListActive
      , view_full_area = Navigation.Authenticate
      , login_register_handle = Nothing
      , login_register_keyphrase = Nothing
      , m_error_message = Nothing
      , game_creation_name = Nothing
      , game_creation_board = Nothing
      , m_join_code = Nothing
      }
    , Random.generate Types.CatchRandomGeneratorSeedFE Random.independentSeed
    )


view : Model -> Browser.Document FrontendMsg
view model =
    { title = "Trick Tac Toe"
    , body =
        [ HS.toUnstyled <|
            Home.root model
        ]
    }
