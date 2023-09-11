module Frontend exposing (..)

import Browser exposing (UrlRequest(..))
import Browser.Navigation as Nav
import Html
import Html.Attributes as Attr
import Lamdera
import Types exposing (..)
import Url
import Types.Board as Board
import Frontend.UI.Home as Home
import Frontend.Update as FrontendUpdate
import Frontend.UpdateFromBackend as UpdateFromBackend
import Html.Styled as HS
import Html.Styled.Attributes as HSA
import Types.Player as Player


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
      , next_coordinate = Nothing
      , board = Board.Regular Board.boardRegular
      , player_one = Player.defaultOne
      , player_two = Player.defaultTwo
      , current_player = Player.defaultOne
      }
    , Cmd.none
    )



view : Model -> Browser.Document FrontendMsg
view model =
    { title = "Trick Tac Toe"
    , body =
        [ HS.toUnstyled <|
           Home.root model
        ]
    }